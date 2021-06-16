
<template>
  <div class="menu-container">
    <div class="header">

    </div>
    <div class="menu-items-area">
        <div ref="menu-elem" class="menu-item connections active" @click="$emit('menu-selection', 'connections')">
            Verbindungen
        </div>
        <div ref="menu-elem" class="menu-item history" @click="$emit('menu-selection', 'history')">
            Meine Fahrten
        </div>
    </div>
  </div>
</template>


<script>
export default {
    name: 'Menu',
    methods: {
        selectTab: function(menu_elem) {
            console.log(this.$refs);

            const active_elem = document.querySelector('div.menu-item.active');
            if (active_elem) {
                active_elem.classList.remove('active');
            }

            const elem = document.querySelector(`div.menu-item.${menu_elem}`);
            if (elem) {
                elem.classList.add('active');
            }
        }
    }
}
</script>


<style scoped>
@import url('../css/root.css');
@import url('../css/fonts.css');

* {
    box-sizing: border-box;
}

.icon {
    color: var(--icon-color);
}

div.menu-container {
    display: flex;
    flex-direction: column;
}

div.header {
    height: 30px;
}


div.menu-items-area {
    display: flex;
    justify-content: center;
    align-items: center;
}


div.menu-item {
    width: 200px;
    height: calc(100% - 2.5px);
    font-family: 'HeaderFontRegular';
    padding: 20px;
    text-align: center;
    color: var(--on-bg-color-medium);
    border-bottom: 1.5px solid transparent;
}

div.menu-item:hover {
    border-bottom: 1.5px solid var(--secondary-color);
    color: var(--on-bg-color-light);
    cursor: pointer;
}


div.menu-item.active {
    color: var(--primary-color-light);
    color: white;
    font-weight: bold;
    border-bottom: 1.5px solid var(--secondary-color-light);
    transition: all linear 0.2;
}


</style>

