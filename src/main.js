import Vue from "vue";
import App from "./App.vue";
import vuetify from "./plugins/vuetify";
import AceEditor from "vue-editor-ace";

Vue.config.productionTip = false;

Vue.use(AceEditor);

new Vue({
  vuetify,
  render: h => h(App)
}).$mount("#app");
