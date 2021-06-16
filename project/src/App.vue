
<template>
    <div id="background-radial-gradient"></div>
    <div id="body">
        <!-- <Header id="header"/> -->
        <Menu id="menu" @menu-selection="menuSelection"/>
        <Connections id="connections"
                     @connection-selection="selectConnectionForPayment"
                     class="menu-element"
                     headerTitle="Verbindung suchen"/>

        <PaymentMenu id="payment"
                     @return-to-connections="goBackToConnections"
                     headerTitle="Angaben zum Ticket"
                     :connection="selectedConnection"/>

        <!-- <ContractArea id="contract" class="menu-element" headerTitle="Contract"/> -->
        <!-- <Footer id="footer"></Footer> -->
    </div>
</template>


<script>
import Header from './components/Header';
import Menu from './components/Menu';
import Connections from './components/Connections';
// import ContractArea from './components/ContractArea';
// import Footer from './components/Footer';
import PaymentMenu from './components/PaymentMenu';


export default {
  name: "App",
  components: {
    Header,
    Menu,
    Connections,
    // ContractArea,
    // Footer,
    PaymentMenu
  },


    data() {
        return {
            selectedConnection: {}
        }
    },

  methods: {
      menuSelection: function(...args) {
        console.log([...args]);
        Menu.methods.selectTab(...args);

        const menu_elements = document.querySelectorAll('.menu-element');

        for (const elem of menu_elements) {
            elem.style.visibility = "hidden";
        }

        const selected = document.querySelector(`#${args[0]}`);
        if (selected) {
            selected.style.visibility = 'visible';
        }
      },

    selectConnectionForPayment(connection) {
        console.log({RECEIVED_PAYMENT_EVENT: connection});
        const connections_view = document.querySelector('#connections');
        connections_view.style.visibility = 'hidden';

        const payment_view = document.querySelector('#payment');
        payment_view.style.visibility = 'visible';
        this.selectedConnection = connection;
        console.log({this: this});
    },

    goBackToConnections() {
        const connections_view = document.querySelector('#connections');
        connections_view.style.visibility = 'visible';

        const payment_view = document.querySelector('#payment');
        payment_view.style.visibility = 'hidden';
    }
  }
};
</script>


<style>
@import url('./css/fonts.css');


#background-radial-gradient {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    pointer-events: none;
    width: 200vw;
    height: 200vh;
    mix-blend-mode: color;
    background: radial-gradient(50% 50% at 50% 50%,#fc077d10 0,rgba(255,255,255,0) 100%);
    transform: translate(-50vw,-100vh);
    z-index: -1;
}


* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}


body, html {
    /* background: radial-gradient(50% 50% at 50% 50%,#fc077d10 0,rgba(255,255,255,0) 100%); */
    /* transform: translate(-50vw,-100vh); */
    z-index: -1;
    padding: 0;
    margin: 0;
    box-sizing: border-box;
}


html {
    /* background: var(--bg-color); */
background-color: rgb(33, 36, 41) !important;
}


div#body {
    margin: 0;
    padding: 0;
    display: grid;
    position: fixed;
    top: 0px;
    left: 0;
    right: 0;
    bottom: 0;
    /* height: 90%; */
    /* width: 100%; */
    /* width: 100vw; */
    /* height: 100%; */
    /* overflow: hidden; */
    /* grid-template-columns: minmax(100px, 150px) 1fr 1fr;
    grid-template-rows: 60px 1fr 100px; */
    grid-template-columns: 1fr 1fr;
    grid-template-rows: 60px 1fr 100px;
}


#menu {
    /* background: yellow; */
    border-bottom: 1px solid var(--border-color-grey);
    grid-row-start: 1;
    grid-row-end: 2;
    grid-column-start: 1;
    grid-column-end: 3;
}
/* 
#header {
    grid-row-start: 2;
    grid-row-end: 4;
    grid-column-start: 1;
    grid-column-end: 2;
} */


#connections {
    grid-column-start: 1;
    grid-column-end: 3;
    grid-row-start: 2;
    grid-row-end: 3;
}


#payment {
    visibility: hidden;
    grid-column-start: 1;
    grid-column-end: 3;
    grid-row-start: 2;
    grid-row-end: 3;
}

#footer {
    grid-row-start: 3;
    grid-row-end: 4;
    grid-column-start: 1;
    grid-column-end: 4;
    
}


@media (min-width: 550px) and (max-width: 1000px),
(min-width: 0px) and (max-width: 549px)
{
    div#body {
        display: grid;
        width: 100vw;
        height: 100vh;
        grid-template-columns: 0 1fr 0;
        grid-template-rows: 60px 1fr minmax(70px, 100px);
    }

    #menu,
    #contract
    {
        visibility: hidden;
    }
}

</style>
