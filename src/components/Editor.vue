<template>
  <div id="ace-editor-wrapper">
    <AceEditor
      v-model="src"
      :config="$store.state.AceConfig.config"
      ref="aceEditor"
    />
  </div>
</template>

<script>
const computedEmitter = {
  get() {
    return this.value;
  },
  set(newValue) {
    this.$emit("dirty", true);
    this.$emit("input", newValue);
  }
};

export default {
  name: "Editor",
  props: {
    value: String
  },

  mounted() {
    const aceEditor = this.$refs["aceEditor"];
    this.$store.dispatch("AceConfig/setEditorRef", aceEditor);
  },

  computed: {
    src: computedEmitter
  }
};
</script>

<style>
#ace-editor-wrapper {
  height: 65vh;
}
</style>
