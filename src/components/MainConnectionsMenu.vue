<template>
    <div class="connections-menu">
        <h3>{{ news.title }}</h3>
        <p>{{ news.text }}</p>
        <div class="tickers-container">
          <div v-for="(ticker, idx) in news.tickers" :key="idx" class="ticker-tag">
            {{ ticker }}
          </div>
        </div>
    </div>  
</template>


<script>
export default {
    name: 'MainConnectionsMenu',

    props: [
      'news'
    ],

    data() {
      return {
        data: {
          news: {}
        }
      }
    }
};
</script>


<style scoped>
div.connections-menu * {
  box-sizing: border-box;
}


div.connections-menu {
    background: var(--surface-color-2dp);
    box-sizing: border-box;
    margin: 0;
    padding: 0;
    padding: var(--container-padding);
    color: var(--on-bg-color-medium);
    border-radius: 4px;
    margin: 5px;
    box-shadow: 0 1px 1px #0000002f;
}


div.tickers-container {
  margin: 5px 0 5px 0;
  display: flex;
}

div.ticker-tag {
  font-size: 0.9em;
  padding: 3px 8px 3px 8px;
  background: var(--primary-color-dimm);
  color: var(--primary-color-light);
  border-radius: 3px;
  margin: 2px;
  box-shadow: 0 1px 3px black;
}


h3 {
  color: var(--on-bg-color-light);
  /* margin-bottom: 5px; */
}

p {
  padding: 10px 0 10px 0;
}

@keyframes loading {
  0% {
    background-position: 100% 50%;
  }
  100% {
    background-position: 0 50%;
  }
}

.loading {
  color: transparent;
  /* background: linear-gradient(100deg, #eceff1 30%, #f6f7f8 50%, #eceff1 70%); */
  background: linear-gradient(100deg, #000000 30%, var(--surface-color) 50%, #000000 70%);
  background-size: 400%;
  animation: loading 1.2s ease-in-out infinite;
  margin-bottom: 5px;
  border-radius: 3px;
}
</style>
