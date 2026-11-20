import SwiftUI
import UIKit
import WebKit

/// WebKit-based SpringBoard refresh technique.
/// Technique credit: @neonmodder123; Swift implementation credit: @skadz108.
/// Adapted from the public NeoSpring/Erosion implementations.
struct RespringRunner: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.isScrollEnabled = false
        webView.loadHTMLString(Self.document, baseURL: nil)
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    private static let document = """
    <!DOCTYPE html>
    <html><body>
      <iframe id="frame" srcdoc="" sandbox="allow-forms allow-modals allow-orientation-lock allow-pointer-lock allow-popups allow-presentation allow-scripts"></iframe>
      <script>
        const frame = document.getElementById('frame');
        const payload = `
          <html><body><script>
            const container = document.createElement('div');
            container.style.cssText = 'perspective:1px;perspective-origin:9999999% 9999999%;';
            document.body.appendChild(container);
            for (let i = 0; i < 500; i++) {
              const layer = document.createElement('div');
              layer.style.cssText = 'position:absolute;width:100vw;height:100vh;backdrop-filter:blur(100px);-webkit-backdrop-filter:blur(100px);transform:translate3d(100000px,100000px,' + i + 'px) rotateY(90deg);';
              container.appendChild(layer);
            }
            setInterval(() => {
              navigator.share({title:'R',text:'R'.repeat(100000)}).catch(() => {});
              const bytes = new Uint8Array(1024 * 1024 * 10);
              crypto.getRandomValues(bytes);
            }, 0);
          <\\/script></body></html>`;
        frame.srcdoc = payload;
      </script>
    </body></html>
    """
}
