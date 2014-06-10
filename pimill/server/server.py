from sockjs.tornado import SockJSRouter
from bottle import Bottle,route,template,static_file,request
    
from socket import PiMillSocket

# only needed when you run Bottle on mod_wsgi
from bottle import default_app
import os
import json

STATIC_FILE_PATH='%s%s' % (os.getcwd(), '/static/')
PRESETS_FILE = '%s/config/preset.json' % os.getcwd()


app = default_app()
    
@app.route('/') 
def index():
	return template(
		"index"
    )
    

@route('/css/<filepath:path>')
def css(filepath):
    return static_file(filepath, root='%s%s' % (STATIC_FILE_PATH,'css'))
    
@route('/js/<filepath:path>')
def js(filepath):
    return static_file(filepath, root='%s%s' % (STATIC_FILE_PATH,'js'))
    
@route('/fonts/<filepath:path>')
def fonts(filepath):
    return static_file(filepath, root='%s%s' % (STATIC_FILE_PATH,'fonts'))
    
@route('/img/<filepath:path>')
def img(filepath):
    return static_file(filepath, root='%s%s' % (STATIC_FILE_PATH,'img'))
    

@route('/api/serials')
def serials():
    lst = map( lambda x: '/dev/%s' % x, filter(lambda x: x.count('tty') >0 , os.listdir('/dev/')))
    lst.append('/dev/null')
    return {'serials' : lst}
    
@route('/api/presets')
def presets():
    f = open(PRESETS_FILE,'r')
    data = json.load(f)
    f.close()
    return {'presets' : data}
    
    
def get_save_path():
    return '%s/upload' % os.getcwd()


@route('/upload', method='POST')
def do_upload():
    upload     = request.files.get('upload')
    name, ext = os.path.splitext(upload.filename)
    if ext not in ('.png'):
        return 'File extension not allowed.'

    save_path = '%s/%s' % (get_save_path(), 'image.png')
    upload.save(save_path,overwrite=True) # appends upload.filename automatically
    return {'status' : 'ok' }
    
@route('/uploaded.png', method='GET')
def uploaded():
    return static_file('image.png', root=get_save_path())


@route('/uploaded.path.png', method='GET')
def uploaded():
    return static_file('image.path.png', root=get_save_path())

@route('/uploaded.rml.png', method='GET')
def uploaded():
    return static_file('image.rml', root=get_save_path())


@route('/uploaded_info')
def uploaded_info():
    save_path = '%s/%s' % (get_save_path(), 'image.png')
    save_path_info = '%s.nfo' % save_path
    ret = os.system('file %s > %s' % (save_path,save_path_info))
    if ret > 0:
        return {'status' : 'error'}
    f = open(save_path_info,'r')
    data = f.read()
    f.close()
    d,info = data.split(':')
    info = info.split(',')
    return {'info' : info}


@route('/api/invert', method='POST')
def invert():
    img =   '%s/%s' % (get_save_path(), 'image.png')    
    script = './scripts/invert.sh'
    ret = os.system('%s %s' % (script,img))
    if ret > 0:
        return {'status' : 'error'}
    return {'status' : 'ok'}
    
    
@route('/api/makepath', method='POST')
def make_path():
    preset = request.params.get('data[preset]')
    # todo get other params too and pass them to the scripts
    script = './scripts/make_path_etching.sh'
    if preset == 1:
        script = './scripts/make_path_cutting.sh'
    
    img =   '%s/%s' % (get_save_path(), 'image.png')
    path =  '%s/%s' % (get_save_path(), 'image.path')
    print 'Making path %s %s %s' % (script,img,path)
    ret = os.system('%s %s %s' % (script,img,path))
    if ret > 0:
        return {'status' : 'error'}
    return {'status' : 'ok'}
    
@route('/api/makerml', method='POST')
def make_rml():
    x = request.params.get('data[x]')
    y = request.params.get('data[y]')
    script = './scripts/make_rml.sh'
    path =  '%s/%s' % (get_save_path(), 'image.path')
    rml =  '%s/%s' % (get_save_path(), 'image.rml')
    ret = os.system('%s %s %s %s %s' % (script,path,rml, x, y))
    if ret > 0:
        return {'status' : 'error'}
    return {'status' : 'ok'}
    

@route('/api/move',method='POST')
def move():
    print request.params.keys()
    x = request.params.get('data[x]')
    y = request.params.get('data[y]')
    serial = request.params.get('data[serial]')   
    script = './scripts/rml_move.sh'
    print 'Moving head to %s %s serial %s' % (x,y, serial)
    ret = os.system('%s %s %s %s' % (script,x, y, serial))
    if ret > 0:
        return {'status' : 'error'}
    return {'status' : 'ok'}

class Server():
    def __init__(self, configfile=None, basedir=None, host="0.0.0.0", port=5000, debug=False, allowRoot=False):
        self._app = app
        self._configfile = configfile
        self._basedir = basedir 
        self._host = host
        self._port = port
        self._debug = debug
        self._allowRoot = allowRoot
    
    def run(self):

        from tornado.wsgi import WSGIContainer
        from tornado.httpserver import HTTPServer
        from tornado.ioloop import IOLoop
        from tornado.web import Application, FallbackHandler
        app.debug=self._debug

        self._router = SockJSRouter(self._createSocketConnection, "/sockjs")
        # app.run(host=self._host, port=self._port, server="tornado",reloader=self._debug)
        self._tornado_app = Application(self._router.urls + [
            (r".*", FallbackHandler, {"fallback": WSGIContainer(app)})
            ])
        self._server = HTTPServer(self._tornado_app)
        self._server.listen(self._port, address=self._host)
        IOLoop.instance().start() 

    def _createSocketConnection(self, session):
        return PiMillSocket(session)

    
    
