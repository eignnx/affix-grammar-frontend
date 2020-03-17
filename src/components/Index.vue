<template>
  <main>
    <h1>Affix Grammar</h1>
    <textarea
      v-model="src"
      name="source text"
      id="src-txt"
      cols="80"
      rows="20"
    ></textarea>
    <section>
      <button @click="generate" :disabled="noMoreSentences">Generate</button>
      <button @click="doubleMaxIters">Double Max Iterations</button>
    </section>
    <section>
      <p v-for="(sentence, idx) in sentences" :key="idx">{{ sentence }}</p>
    </section>
  </main>
</template>

<script>
let ParserContext = null;

export default {
  data: () => ({
    src: "",
    sentences: [],
    ctx: null,
    noMoreSentences: false
  }),

  async created() {
    const module = await import("affix-grammar-js");
    ParserContext = module.ParserContext;
  },

  methods: {
    generate() {
      if (this.ctx === null) {
        this.ctx = new ParserContext(this.src);
      }
      try {
        const sentence = this.ctx.generate();
        this.sentences.push(sentence);
      } catch (e) {
        if (e == "Max iterations execeeded.") {
          this.noMoreSentences = true;
        } else {
          throw e;
        }
      }
    },

    doubleMaxIters() {
      this.ctx.set_max_trials(10000); // TODO: actually impl
      this.noMoreSentences = false;
    }
  }
};
</script>

<style>
#src-txt {
  padding: 2ch;
  border-radius: 0.5rem;
  font-weight: bolder;
}
</style>
