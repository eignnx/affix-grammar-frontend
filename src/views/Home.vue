<template>
  <div class="home">
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
                    <Reader :src="src" />
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
  </div>
</template>

<script>
import Editor from "@/components/Editor.vue";
import Reader from "@/components/Reader.vue";
import NavigationDrawer from "@/components/NavigationDrawer.vue";
import SentencesWindow from "@/components/SentencesWindow.vue";

const HELLO_WORLD_EXAMPLE_GIST = "d875c21f7b345567b0d95decdaca6636";

async function fetchGistContent(gistId) {
  const resp = await fetch(`https://api.github.com/gists/${gistId}`);
  const json = await resp.json();
  const fileName = Object.keys(json.files)[0];
  return json.files[fileName].content;
}

export default {
  name: "App",

  async created() {
    this.$vuetify.theme.dark = true;
    await this.loadGist(HELLO_WORLD_EXAMPLE_GIST);
  },

  data: () => ({
    drawer: false,
    src: "",
    sentences: [],
    ctx: null,
    noMoreSentences: false,
    bottomSheet: true
  }),

  methods: {
    async loadGist(gistId) {
      this.src = `-- Loading gist ${gistId}...`;
      let content = null;
      try {
        content = await fetchGistContent(gistId);
      } catch (e) {
        this.src = `-- Error loading gist ${gistId}.`;
        return;
      }
      this.src = content;
    },

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

  components: {
    Editor,
    Reader,
    NavigationDrawer,
    SentencesWindow
  }
};
</script>
