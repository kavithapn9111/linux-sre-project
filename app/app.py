from http.server import BaseHTTPRequestHandler, HTTPServer

class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b"Hello from SRE Project!")

server = HTTPServer(('0.0.0.0', 80), Handler)
server.serve_forever()
