<template>
  <v-bottom-sheet
    hide-overlay
    persistent
    no-click-animation
    scrollable
    v-model="sheetOpen"
  >
    <template v-slot:activator="{ openBottomSheet }">
      <v-btn color="primary" v-on="openBottomSheet" @click="sheetOpen = true">
        Open
      </v-btn>
    </template>
    <v-card>
      <v-card-title>
        <h4>Generated Sentences</h4>
        <v-divider></v-divider>
        <v-btn text color="warning" @click="sheetOpen = !sheetOpen">
          Close
        </v-btn>
      </v-card-title>
      <v-divider></v-divider>
      <v-card-text style="height: 20vh;">
        <v-list>
          <v-list-item-group>
            <template v-for="(sentence, index) in sentences.slice().reverse()">
              <v-list-item :key="sentence" disabled>
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
      </v-card-text>
    </v-card>
  </v-bottom-sheet>
</template>

<script>
export default {
  name: "SentencesWindow",

  props: {
    sentences: {
      type: Array
    }
  },

  data: () => ({
    sheetOpen: false
  })
};
</script>
