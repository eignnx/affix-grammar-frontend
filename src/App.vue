<template>
  <v-app id="affix-grammar-app">
    <NavigationDrawer />

    <v-content>
      <v-container fluid>
        <v-row>
          <v-col>
            <v-toolbar>
              <v-toolbar-title>Edit</v-toolbar-title>
              <v-spacer></v-spacer>

              <SentencesWindow :sentences="sentences" />

              <template>
                <v-btn
                  class="mx-2"
                  @click="doubleMaxIters"
                  v-if="ctx !== null && noMoreSentences"
                >
                  <v-icon>mdi-plus</v-icon>
                  Deeper Search
                  {{ ctx !== null ? `(${ctx.maxTrials * 2})` : `` }}
                </v-btn>

                <v-btn class="mx-2" @click="generate" v-else>
                  <v-icon>mdi-play</v-icon>Generate
                </v-btn>
              </template>
            </v-toolbar>
          </v-col>
        </v-row>

        <v-row>
          <v-col>
            <v-tabs vertical color="pink">
              <v-tab>
                <v-icon left>mdi-book-open-variant</v-icon>
                Read
              </v-tab>
              <v-tab>
                <v-icon left>mdi-pencil</v-icon>
                Edit
              </v-tab>

              <v-tab-item>
                <v-card light flat>
                  <v-card-text>
                    <v-card v-for="(block, idx) in blocks" :key="idx">
                      <v-card-text
                        class="mb-3 body-1 font-weight-medium"
                        v-if="block.Explanation"
                      >
                        {{ block.Explanation }}
                      </v-card-text>
                      <code
                        style="width: 100%"
                        class="pa-3"
                        v-if="block.Code"
                        >{{ block.Code }}</code
                      >
                    </v-card>
                  </v-card-text>
                </v-card>
              </v-tab-item>

              <v-tab-item>
                <v-card light flat>
                  <v-card-text>
                    <Editor v-model="src" @dirty="ctx = null" />
                  </v-card-text>
                </v-card>
              </v-tab-item>
            </v-tabs>
          </v-col>
        </v-row>
      </v-container>
    </v-content>

    <v-footer app>
      <span>&copy; 2020</span>
    </v-footer>
  </v-app>
</template>

<script>
import Editor from "./components/Editor.vue";
import NavigationDrawer from "./components/NavigationDrawer.vue";
import SentencesWindow from "./components/SentencesWindow.vue";

const HELLO_WORLD_EXAMPLE = `
-- Welcome to Affix Grammar!

-- Click the "Generate" button a few times to see what sentences are produced!

rule start
  = "Hello, World!"
  | "¡Hola Mundo!"
  | "こんにちは世界！"
  | "مرحبا بالعالم!"
  | "Salamu, Dunia!"
  | "ياخشىمۇسىز دۇنيا!"
  | "Γειά σου Κόσμε!"
  | "Привіт Світ!"
  | "สวัสดีชาวโลก!"
  | "Bonjour le monde!"
`.trim();

export default {
  name: "App",

  async created() {
    this.$vuetify.theme.dark = true;
  },

  data: () => ({
    drawer: false,
    src: HELLO_WORLD_EXAMPLE,
    sentences: [],
    ctx: null,
    noMoreSentences: false,
    bottomSheet: true
  }),

  methods: {
    generate() {
      const { ParserContext } = this.$wasm.affix_grammar_js;
      if (this.ctx === null) {
        this.ctx = new ParserContext(this.src);
        this.sentences = [];
        this.noMoreSentences = false;
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
      this.ctx.maxTrials *= 2;
      this.noMoreSentences = false;
    }
  },

  computed: {
    blocks() {
      const { LiterateParser } = this.$wasm.affix_grammar_js;
      const parser = new LiterateParser(this.src);
      const arr = [];
      let value = parser.next();
      while (!value.done) {
        const block = value.value;
        arr.push(block);
        value = parser.next();
      }
      return arr;
    }
  },

  components: { Editor, NavigationDrawer, SentencesWindow }
};
</script>
