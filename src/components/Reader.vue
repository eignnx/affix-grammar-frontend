<template>
  <section>
    <v-card class="mb-5" v-for="(block, idx) in blocks" :key="idx">
      <v-card-text
        class="explanation-block"
        v-if="block.Explanation"
        v-html="block.Explanation.trimEnd()"
      />
      <code class="pa-3 code-block" v-if="block.Code">
        {{ block.Code }}
      </code>
    </v-card>
  </section>
</template>

<script>
function iterToArr(iter) {
  const arr = [];
  let res = iter.next();
  while (!res.done) {
    arr.push(res.value);
    res = iter.next();
  }
  return arr;
}

export default {
  name: "Reader",

  props: {
    src: String
  },

  computed: {
    blocks() {
      const { LiterateParser } = this.$wasm.affix_grammar_js;
      const parser = new LiterateParser(this.src);
      return iterToArr(parser);
    }
  }
};
</script>

<style>
.explanation-block p {
  margin-bottom: 0 !important;
}

.code-block {
  width: 100%;
}
</style>
