/// Represents the Ace Editor config.
export default {
  namespaced: true,
  state: {
    // A reference to the component-owned editor instance.
    editorRef: null,
    config: {
      // Language
      lang: "haskell",
      // Theme
      theme: "github",
      // only read.
      readOnly: false,
      // enable Autocompletion
      autoCompletion: false,
      showPrintMargin: false,
      useWrapMode: true,
      useSoftTabs: true,
      tabSize: 2,
      // enable vim keyboard
      useVim: false,
      // enable emmet.
      useEmmet: false,
      // enable beautify code.
      useBeautifyCode: false,
      // set cursor position.
      cursorPosition: { row: 0, column: 0 },
      // set page position (scroll).
      pagePosition: 0
    }
  },

  mutations: {
    SET_EDITOR_REF(state, ref) {
      state.editorRef = ref;
    },
    RELOAD(state) {
      if (state.editorRef) state.editorRef.reload();
    },
    UPDATE_CONFIG(state, property, newValue) {
      state[property] = newValue;
    }
  },

  actions: {
    setEditorRef({ commit }, ref) {
      commit("SET_EDITOR_REF", ref);
    },
    setUseVim({ dispatch }, value) {
      dispatch("updateConfig", "useVim", value);
    },
    updateConfig({ commit }, property, newValue) {
      commit("UPDATE_CONFIG", property, newValue);
      commit("RELOAD");
    }
  },

  getters: {
    config(state) {
      return state.config;
    }
  }
};
