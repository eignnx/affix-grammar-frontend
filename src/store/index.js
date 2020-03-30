import Vue from "vue";
import Vuex from "vuex";
import AceConfig from "./modules/AceConfig.js";

Vue.use(Vuex);

export default new Vuex.Store({
  namespaced: true,
  state: {},
  mutations: {},
  actions: {},
  modules: {
    AceConfig
  }
});
