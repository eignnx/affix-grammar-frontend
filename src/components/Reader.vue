<template>
  <section>
    <v-card v-for="(block, idx) in blocks" :key="idx">
      <v-card-text
        class="mb-3 body-1 font-weight-medium"
        v-if="block.Explanation"
        v-html="block.Explanation"
      />
      <code style="width: 100%" class="pa-3" v-if="block.Code">{{
        block.Code
      }}</code>
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

function renderMarkdown(mdFormat) {
  return block => {
    if (block.Explanation) {
      return { Explanation: mdFormat(block.Explanation) };
    } else {
      return block;
    }
  };
}

export default {
  name: "Reader",

  props: {
    src: String
  },

  computed: {
    blocks() {
      const { LiterateParser } = this.$wasm.affix_grammar_js;
      const { format } = this.$wasm.pulldown_cmark_wasm;
      const parser = new LiterateParser(this.src);
      return iterToArr(parser).map(renderMarkdown(format));
    }
  }
};
</script>
