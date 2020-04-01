import Vue from "vue";
import App from "./App.vue";
import vuetify from "./plugins/vuetify";
import AceEditor from "vue-editor-ace";
import store from './store'
const affix_grammar_js_module = import("affix-grammar-js");

async function setupAffixGrammar(Vue, affix_grammar_js_module) {
  // Asynchronously wait for the module to load.
  const affix_grammar_js = await affix_grammar_js_module;

  // Attach the module to the Vue instance.
  Vue.prototype.$wasm = { affix_grammar_js };
}

(async function() {
  await setupAffixGrammar(Vue, affix_grammar_js_module);

  Vue.config.productionTip = false;

  Vue.use(AceEditor);

  new Vue({
    vuetify,
    store,
    render: h => h(App)
  }).$mount("#app");
})();
