from bottle import Bottle, route, template
from server import Server
import os
import logging
import logging.config



        
if __name__ == "__main__":
    s = Server(debug=True)
    s.run()
