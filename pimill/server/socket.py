from sockjs.tornado import SockJSConnection
import logging
from rml_send import RMLSender
import json
import util


class PiMillSocket(SockJSConnection):
    
    def __init__(self,session):
        SockJSConnection.__init__(self, session)
        self._logger = logging.getLogger(__name__)
        self.sender = None
        
    def on_open(self, info):
        self._logger.info("New connection from client: %s" % self._getRemoteAddress(info))
        
    def on_close(self):
        self._logger.info("Closed client connection")

    def on_message(self, message):
        msg = json.loads(message)
        print "Received message %s" % msg
        if msg['command'] == 'prepareMilling':
            filename = util.get_rml_path()
            self.prepareMilling(msg['payload']['serial'], filename)
        elif msg['command'] == 'startMilling':
            self.startMilling()
        elif msg['command'] == 'stopMilling':
            self.stopMilling()
        

    def writeMessage(self, msg_type, msg):
        self.send({msg_type: msg})

    def _getRemoteAddress(self, info):
        forwardedFor = info.headers.get("X-Forwarded-For")
        if forwardedFor is not None:
            return forwardedFor.split(",")[0]
        return info.ip
        
    def prepareMilling(self, port, filename):
        if self.sender != None:
            self.sender.abort()
        self.sender = RMLSender(port, self)
        self.sender.load_file(filename)
        
    def callback(self, kind, payload):
        if kind == 'done':
            self.doneMilling(payload)
        elif kind == 'progress':
            self.progressMilling(payload)
        elif kind == 'millingInfo':
            self.millingInfo(payload)
        
    def startMilling(self):
        """Start milling the current file"""
        self.sender.start()
        
    def stopMilling(self):
        """Stop / abort milling"""
        self.sender.abort()
        
    def doneMilling(self, payload):
        """Milling is done event"""
        print 'Milling is done'
        total_label = "%02d:%02d s" % (int(payload.total_time)/60,int(payload.total_time) % 60)
        rem_label = "%02d:%02d s" % (int(payload.time_remaining)/60,int(payload.time_remaining) % 60)
        perc = (1-(payload.time_remaining / payload.total_time)) * 100
        
        self.send({'event' : 'done', 'payload' : { 'distance' : payload.total_distance, 'perc' : perc, 'time' : total_label, 'rem' : rem_label }})


        
    def progressMilling(self,payload):
        """Record milling progress event"""
        print 'Milling is progressing %s' % str(payload)
        print 'Distance %s' % payload.total_distance
        print 'Time %s' % payload.total_time
        print 'Time remaining %s' % payload.time_remaining
        total_label = "%02d:%02d s" % (int(payload.total_time)/60,int(payload.total_time) % 60)
        rem_label = "%02d:%02d s" % (int(payload.time_remaining)/60,int(payload.time_remaining) % 60)
        perc = (1-(payload.time_remaining / payload.total_time)) * 100
        
        self.send({'event' : 'info', 'payload' : { 'distance' : payload.total_distance, 'perc' : perc, 'time' : total_label, 'rem' : rem_label }})
        
    def millingInfo(self,payload):
        """Provide milling information"""
        print 'Milling info\n'
        print 'Distance %s' % payload.total_distance
        print 'Time %s' % payload.total_time
        print 'Time remaining %s' % payload.time_remaining
        total_label = "%02d:%02d s" % (int(payload.total_time)/60,int(payload.total_time) % 60)
        rem_label = "%02d:%02d s" % (int(payload.time_remaining)/60,int(payload.time_remaining) % 60)
        perc = (1-(payload.time_remaining / payload.total_time)) * 100
        
        self.send({'event' : 'info', 'payload' : { 'distance' : payload.total_distance, 'perc' : perc, 'time' : total_label, 'rem' : rem_label }})
          
