import { createApp } from "vue";
import App from "./App.vue";
import tooltip from "./tooltips.js";
// import VueHighlightJS from 'vue3-highlightjs'
// import 'highlight.js/styles/monokai.css'
// import 'highlight.js/styles/stackoverflow-dark.css'
// import 'highlight.js/styles/monokai.css'
// import 'highlight.js/styles/night-owl.css'


const app = createApp(App);


app.directive('tooltip', tooltip);
app.mount("#app");
