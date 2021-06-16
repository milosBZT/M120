<template>
    <div class="newsfeed-container">
        <div class="connections-body">
        <div class="error-area" v-if="errorMsgs.length">
            <span v-for="(msg, index) in errorMsgs" :key="index" class="error-tag">
                <span class="error-tag">{{msg}}</span>
            </span>
        </div>

        <!-- <div class="error-area" v-if="errorMsgs.length">{{ errorMsgs.join(' -- ')}}</div> -->
            <div class="connections-box">
                <div class="header">
                    <div class="header-title">{{ headerTitle }}</div>
                    <div class="filter-area">
                    </div>
                </div>
                <form>
                <div class="input-container">
                    <div class="input-area left">
                        <div class="input-field">
                            <label for="start-input">Von</label>
                            <input id="start-input" @keypress="inputKeypress" class="place-input" v-model="form.departurePlace" lazy/>
                        </div>
                        <div class="input-field right">
                            <label for="destination-input">Nach</label>
                            <input id="destination-input" @keypress="inputKeypress" class="place-input" v-model="form.destinationPlace" lazy/>
                        </div>
                    </div>
                    <div class="input-area secondary-row">
                        <div class="input-field">
                            <label for="via-input">via</label>
                            <input id="via-input" class="place-input" placeholder="--" v-model="form.viaPlace"/>
                        </div>
                        <div class=" input-field date-input">
                            <label for="date-input">Abfahrtsdatum</label>
                            <input type="date" id="date-input" class="place-input" v-model="form.date" required/>    
                        </div>
                        <div class=" input-field clock-input">
                            <label for="clock-input">Uhrzeit</label>
                            <input type="time" id="clock-input" class="place-input" v-model="form.time" required/>    
                        </div>
                    </div>
                </div>
                </form>
                <div id="search-button-area" @click="search">
                    <button id="search-button">Suche Verbindungen</button>
                </div>
            </div>
            <div id="connection-table-container">
                <div v-if="failedFindConnections" class="failed-find-connections-div">
                    Es konnten leider keine Verbindungen gefunden werden. Bitte überprüfen Sie die Ortsangaben.
                </div>
                <TxTable id="connections-table"
                         @connection-selection="receivePaymentEvent"
                         :startPlace="form.departurePlace"
                         :exactTitle="exactTitle"
                         :destinationPlace="form.destinationPlace"
                         :connections="connections"
                ></TxTable>
            </div>
        </div>
    </div>
</template>


<script>
import MainConnectionsMenu from './MainConnectionsMenu';
import ConnectionsTable from './ConnectionsTable';
import TxTable from './TxTable.vue';
const NEWS_API_KEY = 'wkrathsw40hnwxw6cal9ilmvl1qz6ljm2ffadmmc';
import axios from 'axios';
const moment = require('moment');
import uniqueId from 'lodash.uniqueid';

export default {
    components: {
        MainConnectionsMenu,
        ConnectionsTable,
        TxTable
    },
    name: 'Connections',
    props: {
        headerTitle: String
    },

   data() {
        return {
            news: [],
            options: [],
            exactTitle: '',
            failedFindConnections: false,
            errorMsgs: [],
            form: {
                departurePlace: '',
                destinationPlace: '',
                viaPlace: '',
                time: '',
                date: ''
            },

            connections: []
        }
    },

    mounted() {
        let date = new Date();
        this.form.date = moment(String(date)).format('YYYY-MM-DD');
        this.form.time = moment(String(date)).format('HH:mm');
    },

    methods: {
        hasError() {
            const err_elems = document.querySelectorAll('.error-input');
            console.log({errElems: err_elems});
            return err_elems && err_elems.length;
        },


        receivePaymentEvent(connectionData) {
            console.log({CATCH_DATA: connectionData});
            this.$emit('connection-selection', connectionData);
        },

        async search(input) {
            console.log(this.form);
            if (this.validateInput()) {
                this.fetchData();
            }
        },



        validateInput() {
            let valid = true;
            this.errorMsgs = [];
            if (!this.form.departurePlace.length) {
                this.markInputError('start-input');
                this.errorMsgs.push(`Bitte Abfahrtsort eingeben`);
                valid = false;
            }
            
            if (!this.form.destinationPlace.length) {
                this.errorMsgs.push(`Bitte Zielort eingeben`);
                this.markInputError('destination-input');
                valid = false;
            }

            return valid;
        },


        async fetchData() {
            console.log("FETCHING API DATA...");

            let url = `https://fahrplan.search.ch/api/route.de.json?from=${this.form.departurePlace}&to=${this.form.destinationPlace}&transportation_types=train&num=6`;
            url = `${url}&time=${this.form.time}`;
            url = `${url}&date=${this.form.date}`;

            if (this.form.viaPlace.length) {
                url = `${url}&via=${this.form.viaPlace}`;
            }

            const data = await axios({
                method: 'get',
                url: url,
                // url: 'http://transport.opendata.ch/v1/connections?from=Lausanne&to=Genève',
                responseType: 'json'
            });

            console.log({DATA: data});
            this.connections = this.formatConnectionsData(data.data.connections);

            if (typeof this.connections !== 'undefined' && this.connections.length) {
                this.failedFindConnections = false;
                this.form.departurePlace = data.data.connections[0].from;
                this.form.destinationPlace = data.data.connections[0].to;
                this.exactTitle = data.data.description;
            } else {
                this.failedFindConnections = true;
            }

            // this.connections.push(...this.formatConnectionsData(data.data.connections));
        },

        formatConnectionsData(data) {
            if (!data) {
                return;
            }

            console.log({receivedData: data});
            const formated = [];

            for (let row of data) {
                formated.push({
                    id: uniqueId('connection-'),
                    from: row.from,
                    to: row.to,
                    line: row.legs[0].line,
                    trainType: row.legs[0].type_name,
                    operator: row.legs[0].operator,
                    departureTime: moment(row.departure).format('HH:mm'),
                    departureDateTime: moment(row.departure).format('YYYY-MM-DD HH:mm'),
                    arrivalDateTime: moment(row.arrival).format('YYYY-MM-DD HH:mm'),
                    arrivalTime: moment(row.arrival).format('HH:mm'),
                    duration: this.secondsToHours(row.duration),
                    hops: row.legs.length - 1,
                    track: row.legs[0].track,
                    price: `234.34 CHF`,
                    typeSvgData: this.getSvg(row.legs[0].type_name),
                });
            }

            console.log({processed: formated});
            return formated;
        },

        getSvg(key) {
            switch (key) {
                case 'Zug':
                    return this.trainSvgData();
                case 'S-Bahn':
                    return this.trainSvgData();
                case 'Bus':
                    return this.busSvgData();
                default:
                    return this.busSvgData();
            }
        },


        trainSvgData() {
            return {
                data: `M17.3 15.7c.2 0 .3-.1.3-.3l-.3-1.9h-3.2v2.2h3.2zm-6.7-9.5L12.3
                        5 10 3.7 7.7 5l1.8 1.2h1.1zm3.3 3.3c0 .2.1.3.3.3h1.6c.2 0
                        .3-.1.3-.3l-.3-2.4c0-.2-.2-.3-.3-.3h-1.3c-.2 0-.3.1-.3.3v2.4zM9.7
                        6.8H2.5v-.6h5.9L6.5 5 10 3l3.5 2-1.9 1.2h3.8c.5 0 .9.3.9.8l.8
                        5.9H2.5V9.8h7.2c.2 0 .3-.1.3-.3 0-.2-.1-.3-.3-.3H2.5v-.6h7.2c.2
                        0 .3-.1.3-.3S9.9 8 9.7 8H2.5v-.6h7.2c.2 0 .3-.1.3-.3 0-.1-.1-.3-.3-.3zM6.5 
                        15c0-.9.7-1.6 1.6-1.6s1.6.7 1.6 1.6-.7 1.6-1.6 1.6c-.9 0-1.6-.7-1.6-1.6m3.7 
                        0c0-.9.7-1.6 1.6-1.6s1.6.7 1.6 1.6-.7 1.6-1.6 1.6-1.6-.7-1.6-1.6M2.5 
                        2.8h15v-.3h-15v.3zm0 14.7h15v-.6h-15v.6zm0-3.9l3.4-.1v2.2H2.5v-2.1z`
            };
        },

        busSvgData() {
            return {
                data: `M4.2 9c0 .2.1.3.3.3h3.8c.2 0 .3-.1.3-.3V5.3c0-.2-.1-.3-.3-.3H4.6c-.2 
                       0-.4.1-.4.3V9zm5.1 1.2c0 .3.2.5.5.5s.5-.2.5-.5V5.4c0-.3-.2-.5-.5-.5s-.5.2-.5.5v4.8zm1.6 0c0 
                       .3.2.5.5.5s.5-.2.5-.5V5.4c0-.3-.2-.5-.5-.5s-.5.2-.5.5v4.8zm1.6.1c0 
                       .2.1.3.3.3h1.7c.2 0 .3-.1.3-.3v-.1l-1.3-4.9c0-.2-.2-.4-.5-.4s-.5.2-.5.5v4.9zM3.3 5H.5v-.7h12.6c.5 
                       0 1 .3 1.1.8l1.3 5v3.5c0 .3-.2.5-.5.5H9.2c-.3 0-.5-.2-.5-.5v-.1c0-1.6-1.3-2.9-2.9-2.9-1.6 0-2.9 1.3-2.9 2.9v.1c0 
                       .3-.2.5-.5.5H.5V9.4h2.8c.2 0 .3-.1.3-.3V5.3c0-.2-.1-.3-.3-.3z`,
                additional: `M5.8 14.7c.7 0 1.2-.6 1.2-1.2s-.5-1.3-1.2-1.3-1.3.6-1.3 1.3c0 
                             .7.6 1.2 1.3 1.2m0-3.4c1.2 0 2.2 1 2.2 2.2s-1 2.2-2.2 2.2c-1.2 
                             0-2.2-1-2.2-2.2s1-2.2 2.2-2.2`
            }
        },

        formatDateTime(dt) {
            // let dt = new Date();
            let a = moment(dt).format('h:mm');
            return a;
            // console .log(a);
            // return;
        },

        secondsToHours(seconds) {
            let hours = moment.duration(seconds * 1000).asHours();
            let parts = hours.toString().split('.');
            let fraction = `0.${parts[1]}`;
            let minutes = parseInt(parseFloat(fraction) * 60);
            return `${parts[0]} h ${minutes} min`;
            // console.log(parts);
            // return hours;
        },


        inputKeypress(event) {
            console.log(event.target.id);
            const input = document.querySelector(`#${event.target.id}`);
            input.classList.remove('error-input');
            this.error = this.hasError();
        },


        markInputError(htmlElement) {
            let element = document.querySelector(`#${htmlElement}`);
            if (element) {
                element.classList.add('error-input');
            }
        }
    }
}
</script>


<style scoped>
@import url('../css/fonts.css');
@import url('../css/root.css');

/* .date-input, .clock-input {
    justify-content: flex-end;
    margin-right: 0;
    margin-left: auto;
} */
.error-tag {
    background: rgb(63, 33, 33);
    padding: 7px 5px 7px 5px;
    border-radius: 10px;
    font-size: 1em;
    color: rgb(255, 75, 75);
    margin-left: 10px;
}

.error-area {
    /* width: 100%; */
    position: absolute;
    top: 60px;
    min-width: 500px;
    max-width: fit-content;
    margin-top: 10px;
    margin-bottom: 0;
    min-height: 20px;
    background: none;
    /* background: rgb(63, 33, 33); */
    /* padding: 10px; */
    border-radius: 10px;
    /* color: rgb(255, 75, 75); */
    display: flex;
    font-size: 0.9em;
    justify-content: center;
    align-items: center;
}

.failed-find-connections-div {
    display: flex;
    justify-content: center;
    padding-top: 50px;
    font-size: 1.45em;
    text-align: center;
    color: var(--on-bg-color-light);
}


::-webkit-calendar-picker-indicator {
    filter: invert(1);
}


.newsfeed-container * {
    box-sizing: border-box;
    font-family: 'HeaderFontRegular';
    /* padding-top: 30px; */
}


.error-input, .error-input:focus {
    border: 1px solid rgb(209, 100, 100);
    box-shadow: 0px 0px 3px 0.2px rgb(221, 101, 101);
}


tx-table {
    height: 200px;
}


div.newsfeed-container {
    overflow: hidden;
    margin: 0;
    border-right: 1px solid var(--border-color-grey);
    padding: 0;
}

div.header {
    display: flex;
    justify-content: center;
    /* padding: 10px 20px 0 20px; */
}

div.header-title {
    font-family: 'HeaderFontRegular';
    color: var(--on-bg-color-light);
    font-size: 1.2em;
    width: 100%;
    padding: calc(var(--container-padding) - 5px);
    padding-top: 5px;
}

div.filter-area {
    font-size: 0.85em;
    margin-right: 0;
    margin-left: auto;
    padding: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
}


div.input-container {
    display: flex;
    flex-direction: column;
    border-radius: 20px;
    background: var(--bg-color-lighter);
    border: 1px solid var(--border-color-darker);
}



div.connections-body {
    height: 100%;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    box-sizing: border-box;
    overflow-y: scroll;
}


div.connections-box {
    display: flex;
    flex-direction: column;
    margin-top: 55px;
    width: 40%;
    min-width: 600px;
    max-width: 600px;
    /* height: 50%; */
    height: max-content;
    padding: 8px;
    background: rgb(25, 27, 31);
    box-shadow: rgb(0 0 0 / 1%) 0px 0px 1px, rgb(0 0 0 / 4%) 0px 4px 8px, rgb(0 0 0 / 4%) 0px 16px 24px, rgb(0 0 0 / 1%) 0px 24px 32px;
    border-radius: 24px;
    /* margin-top: 1rem; */
    /* transition: all linear 100ms; */
}

div.input-field {
    display: flex;
    flex-direction: column;
    width: 50%;
    align-content: center;
    padding: 0 10px 0 10px;
}


div.input-area {
    display: flex;
    align-items: center;
    justify-content: center;
    height: 100px;
    /* flex-direction: column; */
    width: 100%;
    /* padding: 10px; */
    /* padding-bottom: 5px; */
    padding: 0px 5px 0px 5px;
    /* background: green; */
}
/* 
div.left, div.right {
    width: 50%;
    display: flex;
    justify-content: center;
}
 */

label {
    font-size: 0.9em;
    color: var(--on-bg-color-light);
}

input {
    background: var(--bg-color-darker);
    margin-top: 10px;
    padding-left: 10px;
    /* width: 500px; */
    color: var(--on-bg-color-light);
    outline: none;
    height: 3.0em;
    border-radius: 5px;
    border: 1px solid var(--border-color);
    box-shadow: none;
    /* background: var(--bg-color); */
    background: var(--bg-color-darker);
}

input:focus {
    border: 1px solid var(--secondary-color);
    box-shadow: 0px 0px 3px 0.2px var(--secondary-color);
}

div.token-detail-area {
    margin-top: 40px;
}


div.switch-arrow-div {
    position: fixed;
    border: 5px solid var(--bg-color-lighter);
    /* background: var(--bg-color); */
    background: rgb(25, 27, 31);
    margin-top: 27px;
    width: 30px;
    height: 30px;
    border-radius: 10px;
    z-index: 3;
}

div.switch-arrow-div div {
    background: var(--bg-color-lighter);
}


#search-button-area {
    width: 100%;
    margin-bottom: 0!important;
    margin-top: auto;
    display: flex;
    justify-content: center;
    padding-bottom: 0px;
    padding: 13px 0 0 0;
    /* margin-top: auto; */
    /* margin-bottom: 0; */    
    /* bottom: 0; */
    /* position: absolute; */
}

button#search-button {
    /* background: var(--secondary-color-semi); */
    /* color: var(--on-bg-color-medium); */
    /* background: var(--secondary-color); */
    background: var(--button-color);
    color: white;
    outline: none;
    border: none;
    font-size: 1.1em;
    box-shadow: none;
    height: 45px;
    border-radius: 16px;
    width: 100%;
    cursor: pointer;
    /* margin-left: auto; */
    /* margin-right: auto; */
    /* font-weight: bold; */
}


button#search-button:hover {
    background: var(--secondary-color);
}

button#search-button:active {
    background: var(--button-color-pressed);
}




input#clock-input {
    width: 100px;
}

div.secondary-row {
    justify-content: flex-start;
    margin-top: -15px;
    margin-bottom: 10px;
}

div.filter-button {
    border-radius: 5px;
    padding: 4px 10px 4px 10px;
    margin: 3px;
}

div.filter-button:hover {
    cursor: pointer;
}


.green {
    background-color: rgba(30, 202, 184, 0.15) !important;
    color: #1ecab8 !important;
}


#connection-table-container {
    max-width: 80%;
    min-width: 80%;
    /* height: 200px; */
}



</style>
