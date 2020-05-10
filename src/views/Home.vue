<template>
  <div class="home">
    <NavigationDrawer />

    <v-content>
      <v-container fluid>
        <v-row>
          <v-col>
            <v-toolbar>
              <v-toolbar-title>
                <a :href="gistLink" v-if="gistLink">{{ title }}</a>
                <span v-else>{{ title || "Edit" }}</span>
              </v-toolbar-title>
              <small class="ml-4" v-if="author !== null">
                by
                <a :href="authorLink" v-if="authorLink">{{ author }}</a>
                <span v-else>UNKNOWN</span>
              </small>

              <v-spacer></v-spacer>

              <template>
                <v-btn
                  v-if="ctx !== null && noMoreSentences"
                  class="mx-2"
                  @click="doubleMaxIters"
                >
                  <v-icon>mdi-plus</v-icon>
                  Deeper Search
                  {{ ctx !== null ? `(${ctx.maxTrials * 2})` : `` }}
                </v-btn>

                <v-btn v-else class="mx-2" @click="generate">
                  <v-icon>mdi-play</v-icon>Generate
                </v-btn>
              </template>
            </v-toolbar>
          </v-col>
        </v-row>

        <v-row>
          <v-col v-if="sentencesWindow">
            <v-card>
              <v-banner
                v-model="sentencesWindow"
                transition="slide-x-transition"
              >
                <h3>Generated Sentences</h3>

                <v-list>
                  <v-list-item-group>
                    <template
                      v-for="(sentence, index) in sentences.slice().reverse()"
                    >
                      <v-list-item :key="sentence" disabled>
                        <template>
                          <v-list-item-content>
                            <!-- <v-list-item-title v-text="sentence" /> -->
                            <p v-text="sentence" />
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

                <template v-slot:actions="{ dismiss }">
                  <v-btn text @click="dismiss">Close</v-btn>
                </template>
              </v-banner>
            </v-card>
          </v-col>
          <!-- </v-row>

        <v-row> -->
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
                    <Editor v-model="src" @dirty="srcChanged" />
                  </v-card-text>
                </v-card>
              </v-tab-item>
            </v-tabs>
          </v-col>
        </v-row>

        <template>
          <div class="text-center ma-2">
            <v-snackbar v-model="errorSnack" :timeout="0" color="error">
              {{ errorSnackMsg }}
              <v-btn color="pink" text @click="errorSnack = false">
                Close
              </v-btn>
            </v-snackbar>
          </div>
        </template>
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

const HELLO_WORLD_EXAMPLE_GIST = "d875c21f7b345567b0d95decdaca6636";

async function fetchGistContent(gistId) {
  const resp = await fetch(`https://api.github.com/gists/${gistId}`);
  const json = await resp.json();
  const fileName = Object.keys(json.files)[0];
  return {
    content: json.files[fileName].content,
    title: fileName,
    gistLink: json.html_url,
    author: json.owner.login,
    authorLink: json.owner.html_url,
  };
}

export default {
  name: "App",

  async created() {
    this.$vuetify.theme.dark = true;
    const params = new URLSearchParams(location.search);
    const gist = params.get("gist") || HELLO_WORLD_EXAMPLE_GIST;
    await this.loadGist(gist);
  },

  data: () => ({
    title: null,
    gistLink: null,
    author: null,
    authorLink: null,
    src: "",
    sentences: [],
    ctx: null,
    noMoreSentences: false,
    bottomSheet: true,
    errorSnack: false,
    errorSnackMsg: "",
    sentencesWindow: false,
  }),

  methods: {
    async loadGist(gistId) {
      this.src = `-- Loading gist ${gistId}...`;
      try {
        const {
          content,
          title,
          gistLink,
          author,
          authorLink,
        } = await fetchGistContent(gistId);
        this.src = content;
        this.title = title;
        this.gistLink = gistLink;
        this.author = author;
        this.authorLink = authorLink;
      } catch (e) {
        this.src = `-- Error loading gist ${gistId}.`;
      }
    },

    srcChanged() {
      this.ctx = null;
      const EDITIED_MARKER = " (edited)";
      if (this.title && !this.title.endsWith(EDITIED_MARKER)) {
        this.title = this.title + EDITIED_MARKER;
        this.gistLink = null;
        this.author = null;
        this.authorLink = null;
      }
    },

    generate() {
      this.sentencesWindow = "open";
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
          console.log(e);
          this.errorSnackMsg = "DYNAMIC ERROR: " + printDynamicError(e);
          this.errorSnack = true;
        }
      }
    },

    doubleMaxIters() {
      this.ctx.maxTrials *= 2;
      this.noMoreSentences = false;
    },
  },

  components: {
    Editor,
    Reader,
    NavigationDrawer,
  },
};

function printDynamicError(e) {
  if (e.UnboundRuleName) {
    const { rule_name } = e.UnboundRuleName;
    return `You typed '${rule_name}' where I was expecting a rule reference. \
            Is this a typo? If you are trying to output a data variant, \
            please put the '@' symbol in front.`;
  }
  if (e.WrongArityRuleReference) {
    const {
      arguments: args,
      rule_name,
      expected_len,
    } = e.WrongArityRuleReference;
    return `Hmmm. It looks like you didn't send the rule '${rule_name}' the \
            correct number of values. I was expecting to get ${expected_len} \
            ${pluralize("value", expected_len)}, but I got \
            ${conj(args, "and")}.`;
  }
  if (e.InexhaustiveCaseAnalysis) {
    const { rule_name, arguments: args } = e.InexhaustiveCaseAnalysis;
    const fmt_args = args.map((arg) => arg.value);
    return `Oops! Looks like the rule '${rule_name}' doesn't cover all \
            possible cases. For instance, what sentence should \
            '${rule_name}.${fmt_args.join(".")}' produce?`;
  }
  if (e.NoDataVariantStringification) {
    const { symbol } = e.NoDataVariantStringification;
    return `I don't know how to properly stringify the data-variant \
            '${symbol}'. You'll have to show my how like this: data ... = \
            ${symbol} ("<textual representation of ${symbol} here>") | ...`;
  }

  return JSON.stringify(e);
}

function conj(arr, conjunction) {
  switch (arr.length) {
    case 0:
      return "nothing";

    case 1:
      return `'${arr[0]}'`;

    case 2:
      return `'${arr[0]}' ${conjunction} '${arr[1]}'`;

    default:
      return `'${arr[0]}', ${conj(arr.slice(1), conjunction)}`;
  }
}

function pluralize(word, n) {
  if (n != 1) {
    return word + "s";
  } else {
    return word;
  }
}
</script>
