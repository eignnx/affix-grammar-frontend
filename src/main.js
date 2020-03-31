import Vue from "vue";
import App from "./App.vue";
import vuetify from "./plugins/vuetify";
import AceEditor from "vue-editor-ace";
import store from "./store";
const affix_grammar_js_module = import("affix-grammar-js");
const pulldown_cmark_wasm_module = import("pulldown-cmark-wasm");

async function setupWasmModules() {
  // Asynchronously wait for the module to load.
  const affix_grammar_js = await affix_grammar_js_module;
  const pulldown_cmark_wasm = await pulldown_cmark_wasm_module;

  // Attach the module to the Vue instance.
  Vue.prototype.$wasm = {
    affix_grammar_js,
    pulldown_cmark_wasm
  };
}

(async function() {
  await setupWasmModules();

  Vue.config.productionTip = false;

  Vue.use(AceEditor);

  new Vue({
    vuetify,
    store,
    render: h => h(App)
  }).$mount("#app");
})();
