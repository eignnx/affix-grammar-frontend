<template>
  <div>
    <v-navigation-drawer v-model="drawer" app clipped>
      <v-list dense>
        <v-list-group
          v-model="savesOpen"
          prepend-icon="mdi-content-save"
          no-action
        >
          <template v-slot:activator>
            <v-list-item-content>
              <v-list-item-title v-text="'Saves'"></v-list-item-title>
            </v-list-item-content>
          </template>

          <v-list-item v-for="save in saves" :key="save.key">
            <v-list-item-content>
              <v-list-item-title v-text="save.title"></v-list-item-title>
              <v-row>
                <v-col>
                  <span class="caption">{{ save.modified }}</span>
                </v-col>
              </v-row>
              <v-row>
                <v-col>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on }">
                      <v-btn icon color="yellow" v-on="on">
                        <v-icon>mdi-file-edit</v-icon>
                      </v-btn>
                    </template>
                    <span>Edit</span>
                  </v-tooltip>
                </v-col>
                <v-col>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on }">
                      <v-btn icon color="info" v-on="on">
                        <v-icon>mdi-file-download</v-icon>
                      </v-btn>
                    </template>
                    <span>Download</span>
                  </v-tooltip>
                </v-col>
                <v-col>
                  <v-tooltip bottom>
                    <template v-slot:activator="{ on }">
                      <v-btn icon color="error" v-on="on">
                        <v-icon>mdi-delete-forever</v-icon>
                      </v-btn>
                    </template>
                    <span>Delete</span>
                  </v-tooltip>
                </v-col>
              </v-row>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>

        <v-list-group v-model="settingsOpen" prepend-icon="mdi-cog" no-action>
          <template v-slot:activator>
            <v-list-item-content>
              <v-list-item-title v-text="'Settings'"></v-list-item-title>
            </v-list-item-content>
          </template>

          <v-list-item>
            <v-list-item-content>
              <v-switch
                @change="updateUseVim"
                label="Vim Keybindings"
              ></v-switch>
            </v-list-item-content>
          </v-list-item>
        </v-list-group>
      </v-list>
    </v-navigation-drawer>

    <v-app-bar app clipped-left>
      <v-app-bar-nav-icon @click="drawer = !drawer" />
      <v-toolbar-title>Affix Grammar</v-toolbar-title>
      <v-spacer></v-spacer>
      <v-btn href="/?gist=5658476af6dbd36dbc7f73594976e8dd">
        <v-icon left>mdi-help-circle-outline</v-icon>Learn
      </v-btn>
    </v-app-bar>
  </div>
</template>

<script>
export default {
  name: "NavigationDrawer",

  data: () => ({
    drawer: false,
    savesOpen: false,
    saves: [
      { title: "Test Grammar 1", key: "grammar1", modified: "Three days ago" },
      {
        title: "English Sentence",
        key: "english-sentence",
        modified: "Feb 29, 2020"
      }
    ],
    examplesOpen: false,
    settingsOpen: false
  }),

  methods: {
    updateUseVim(value) {
      this.$store.dispatch("AceConfig/setUseVim", value);
    }
  }
};
</script>

<style></style>
