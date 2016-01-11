// Copyright (c) 2011 The Chromium Embedded Framework Authors. All rights
// reserved. Use of this source code is governed by a BSD-style license that
// can be found in the LICENSE file.

#import <Cocoa/Cocoa.h>

#include "cefclient/client_handler.h"
#include "include/cef_browser.h"
#include "include/cef_frame.h"
//#include "cefclient/cefclient.h"
#include "chromium_loader/jni_tools.h"

namespace client {

void ClientHandler::OnAddressChange(CefRefPtr<CefBrowser> browser,
                                    CefRefPtr<CefFrame> frame,
                                    const CefString& url) {
  CEF_REQUIRE_UI_THREAD();

  if (GetBrowserId() == browser->GetIdentifier() && frame->IsMain()) {
    // Set the edit window text
    NSTextField* textField = (NSTextField*)edit_handle_;
    std::string urlStr(url);
    NSString* str = [NSString stringWithUTF8String:urlStr.c_str()];
    [textField setStringValue:str];
  }
}

void ClientHandler::OnTitleChange(CefRefPtr<CefBrowser> browser,
                                  const CefString& title) {
  CEF_REQUIRE_UI_THREAD();

  // Set the frame window title bar
  NSView* view = (NSView*)browser->GetHost()->GetWindowHandle();
  if (GetBrowserId() == browser->GetIdentifier()) {
    if (id != browser->GetHost()->GetClient()->id)
      fprintf(stderr, "ClientHandler::OnTitleChange id is not the same\n");

    // Send title to java side if the browser is not closed.
    if (id != -1)
      set_title(std::string(title).c_str(), id);
  } else {
    NSWindow* window = [view window];
    std::string titleStr(title);
    NSString* str = [NSString stringWithUTF8String:titleStr.c_str()];
    [window setTitle:str];
  }
}

void ClientHandler::SetLoading(bool isLoading) {
  if (id != -1)
    send_load(id, isLoading);
}

void ClientHandler::SetNavState(bool canGoBack, bool canGoForward) {
  // TODO(port): Change button status.
}

}  // namespace client
