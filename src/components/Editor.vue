<template>
  <v-textarea
    solo
    v-model="src"
    name="source-text"
    id="src-txt"
    rows="10"
    no-resize
    auto-grow
    placeholder="Your grammar goes here..."
  ></v-textarea>
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

  computed: {
    src: computedEmitter
  }
};
</script>

<style>
#src-txt {
  font-family: monospace;
  font-weight: bolder;
}
</style>
