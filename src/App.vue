<template>
  <v-app id="affix-grammar-app">
    <v-navigation-drawer v-model="drawer" app clipped>
      <v-list dense>
        <v-list-item link>
          <v-list-item-action>
            <v-icon>mdi-view-dashboard</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Dashboard</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
        <v-list-item link>
          <v-list-item-action>
            <v-icon>mdi-settings</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title>Settings</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar app clipped-left>
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-toolbar-title>Affix Grammar</v-toolbar-title>
    </v-app-bar>

    <v-content>
      <v-container fluid>
        <v-row>
          <v-col>
            <v-toolbar>
              <v-toolbar-title>Edit</v-toolbar-title>
              <v-spacer></v-spacer>

              <v-switch
                v-model="config.useVim"
                label="Vim Keybindings"
              ></v-switch>
            </v-toolbar>
          </v-col>
        </v-row>
        <v-row>
          <v-col>
            <Editor v-model="src" @dirty="ctx = null" :config="config" />
          </v-col>
          <v-col>
            <v-card class="mx-auto">
              <v-list>
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
                    <v-icon>mdi-play</v-icon>
                    Generate
                  </v-btn>
                </template>
                <v-subheader>Generated Sentences </v-subheader>
                <v-list-item-group>
                  <template
                    v-for="(sentence, index) in sentences.slice().reverse()"
                  >
                    <v-list-item :key="sentence" :disabled="ctx === null">
                      <template>
                        <v-list-item-content>
                          <v-list-item-title v-text="sentence" />
                        </v-list-item-content>
                        <v-list-item-action>
                          <v-list-item-action-text
                            v-text="sentences.length - index"
                          />
                        </v-list-item-action>
                      </template>
                    </v-list-item>

                    <v-divider
                      v-if="index + 1 < sentences.length"
                      :key="index"
                    ></v-divider>
                  </template>
                </v-list-item-group>
              </v-list>
            </v-card>
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
let ParserContext = null;
import("affix-grammar-js").then(module => {
  ParserContext = module.ParserContext;
});

const HELLO_WORLD_EXAMPLE = `
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
      tabSize: 4,
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
  }),

  methods: {
    generate() {
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

  components: { Editor }
};
</script>
