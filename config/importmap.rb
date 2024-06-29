# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

pin "@rails/request.js", to: "@rails--request.js.js" # @0.0.9

pin "local-time" # @3.0.2

pin "@github/hotkey", to: "@github--hotkey.js" # @3.1.1

pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8
pin "bootstrap" # @5.2.3

pin "stimulus-password-visibility", to: "https://ga.jspm.io/npm:stimulus-password-visibility@2.1.1/dist/stimulus-password-visibility.mjs", preload: false

# ninja-keys and deps
pin "ninja-keys", to: "https://ga.jspm.io/npm:ninja-keys@1.2.2/dist/ninja-keys.js", preload: false
pin "@lit/reactive-element", to: "https://ga.jspm.io/npm:@lit/reactive-element@1.6.3/reactive-element.js", preload: false
pin "@lit/reactive-element/decorators/", to: "https://ga.jspm.io/npm:@lit/reactive-element@1.6.3/decorators/", preload: false
pin "@material/mwc-icon", to: "https://ga.jspm.io/npm:@material/mwc-icon@0.25.3/mwc-icon.js", preload: false
pin "hotkeys-js", to: "https://ga.jspm.io/npm:hotkeys-js@3.8.7/dist/hotkeys.esm.js", preload: false
pin "lit", to: "https://ga.jspm.io/npm:lit@2.2.6/index.js", preload: false
pin "lit-element/lit-element.js", to: "https://ga.jspm.io/npm:lit-element@3.3.3/lit-element.js", preload: false
pin "lit-html", to: "https://ga.jspm.io/npm:lit-html@2.8.0/lit-html.js", preload: false
pin "lit-html/directives/", to: "https://ga.jspm.io/npm:lit-html@2.8.0/directives/", preload: false
pin "lit/", to: "https://ga.jspm.io/npm:lit@2.2.6/", preload: false
pin "tslib", to: "https://ga.jspm.io/npm:tslib@2.6.2/tslib.es6.mjs", preload: false
