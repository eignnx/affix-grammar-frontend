<template>
  <div id="ace-editor-wrapper">
    <AceEditor v-model="src" :config="config" ref="aceEditor" />
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
    value: String,
    config: Object
  },

  watch: {
    config: {
      deep: true,
      handler() {
        console.log("RELOAD");
        this.$refs["aceEditor"].reload();
      }
    }
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
