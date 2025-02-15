//
//  WebKitView.swift
//  MIDISystemInfo
//  MIDIKit • https://github.com/orchetect/MIDIKit
//

import SwiftUI
import WebKit

struct WebKitView: NSViewRepresentable {
	
	@Binding var dynamicHeight: CGFloat
	
	@Binding var webview: WKWebView
	
	var html: String = ""
	
	class Coordinator: NSObject, WKNavigationDelegate {
		
		var parent: WebKitView
		
		init(_ parent: WebKitView) {
			
			self.parent = parent
			
		}
		
		func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
			
			webView.evaluateJavaScript(
				"document.documentElement.scrollHeight",
				completionHandler: { (height, error) in
					DispatchQueue.main.async {
						if let unwrappedHeight = height as? CGFloat {
							self.parent.dynamicHeight = unwrappedHeight
						}
					}
				})
			
		}
		
	}
	
	func makeCoordinator() -> Coordinator {
		
		Coordinator(self)
		
	}
	
	func setHTML(_ html: String) {
		
		webview.loadHTMLString(html, baseURL: nil)
		
	}
	
	func makeNSView(context: Context) -> WKWebView {
		
		//webview.enclosingScrollView.bounces = false
		webview.navigationDelegate = context.coordinator
		webview.loadHTMLString("", baseURL: nil)
		return webview
		
	}
	
	func updateNSView(_ nsView: NSViewType, context: Context) {
		
		setHTML(html)
		
	}
	
}
