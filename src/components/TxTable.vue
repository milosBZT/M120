<template>
    <div class="no-connections-found" v-if="typeof connections === 'undefined' || !connections.length"></div>
    <div class="table-container" v-else>
        <h1 id="connection-title">{{exactTitle}}</h1>
        <table id="tx-table">
            <thead>
                <tr>
                    <th></th>
                    <th style="text-align: left !important">Linie</th>
                    <th style="text-align: left !important">Abfahrt</th>
                    <th>Dauer</th>
                    <th>Umsteigen</th>
                    <th>Gleis</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(connection, index) in connections" :key="connection.id"
                    v-bind:class="{ odd: index % 2 }">
                    <td class="pictogram-container">
                        <div class="svg-container">
                            <svg viewBox="0 0 20 20" preserveAspectRatio="xMidYMid meet">
                                <path :d="connection.typeSvgData.data"></path>
                                <path :d="connection.typeSvgData.additional"></path>
                            </svg>
                        </div>
                    </td>

                    <td class="td-line"><div>{{connection.line}}</div></td>
                  
                    <td class="departure-arrival-cell">
                        {{connection.departureTime}}
                    </td>
                    <!-- <td><div class="td arrival-time">{{connection.arrivalTime}}</div></td> -->
                    <td><div class="td duration">{{connection.duration}}</div></td>
                    <td><div class="td hops">{{connection.hops}}</div></td>
                    <td v-if="true"><div class="td track">{{connection.track}}</div></td>
                    <td class="td-price">
                        <div class="td price" @click="$emit('connection-selection', emitSelected(connection))">
                            <span style="white-space: nowrap">{{connection.price}}</span>
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
</template>


<script>
const moment = require('moment');
// import * as utils from "../tx.js";
import axios from 'axios';
import uniqueId from 'lodash.uniqueid';
/**
 * 
 */
export default {
    name: 'TxTable',
    props: {
        startDestinationLocations: String,
        startPlace: String,
        destinationPlace: String,
        exactTitle: String,
        connections: Array
    },

    data() {
        // return {
        //     connections: [],
        //     connectionsTitle: 'x'
        // }
    },

    mounted() {
    },


    methods: {
        emitSelected(connection) {
            console.log(connection);
            connection.description = this.exactTitle;
            return connection;
        }
    },
}
</script>


<style scoped>


div.no-connections-found {
    display: flex;
    justify-content: center;
    align-items: center;
}


.connection-operator {
    font-size: 0.8em;
    margin-left: 20px;
}


.table-container {
    /* margin-top: 0px; */
    height: 50vh;
    overflow: auto;
    display: flex;
    height: fit-content;
    /* max-width: 900px; */
    flex-direction: column;
    align-items: center;
}


#connection-title {
    padding: 10px;
    margin: 40px 0 30px 0;
    text-align: center;
    font-size: 1.5em;
    color: var(--on-bg-color-light);
}


table#tx-table {
    transform: scale(1);
    -webkit-transform: scale(1);
    -moz-transform: scale(1);
    position: relative;
    /* display: inline-block; */
    border-spacing: 0;
    border-collapse: separate !important;
    /* padding: 30px; */
    border-radius: 20px;
    width: 100%;
    min-width: 750px;
    height: 100%;
    box-shadow: rgb(0 0 0 / 1%) 0px 0px 1px, rgb(0 0 0 / 4%) 0px 4px 8px, rgb(0 0 0 / 4%) 0px 16px 24px, rgb(0 0 0 / 1%) 0px 24px 32px;
    table-layout: fixed;
    /* width: 500px; */
}


tbody {
    max-height: 400px;
    overflow-y: scroll;
}


table#tx-table th {
    border-radius: 20px;
    position: sticky;
    top: 0;
    /* background: black; */
    /* background: transparent; */
    /* color: white; */
    text-align: left;
    padding: 5px;
}

table#tx-table tr {
    /* padding: 20px; */
    /* background: green; */
    background: var(--bg-color-new);
    min-height: 20px;
    color: var(--on-bg-color-light);
    border-radius: 10px;
}



table#tx-table tr.odd {
    background: var(--bg-color-lighter);
}

h1 {
    color: black;
    font-size: 4em;
}



thead > tr  {
    color: var(--on-bg-color-medium);
    background: transparent !important;
}



table tr:last-child td:first-child {
    border-bottom-left-radius: 10px;
}

table tr:last-child td:last-child {
    border-bottom-right-radius: 10px;
}


td.pictogram {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
}


td.pictogram-container {
    display: flex;
    align-items: center;
    /* justify-content: center; */
    padding-left: 40px;
    /* width: 100px !important; */
}


svg {
    height: 28px;
    width: 28px;
    border-radius: 5px;
    background: #27348b;
    fill: white;
}


.svg-container {
    display: flex;
    justify-content: center;
}


td, th {
    text-align: center !important; 
    vertical-align: middle  !important;
    padding: 8px;
}



td.td-line {
    text-align: left !important;           
}

div.departure-arrival-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin-left: auto;
    margin-right: auto;

}


td.departure-arrival-cell {
    width: max-content;
    text-align: left !important;
    max-width: 100px;
}

div.departure-arrival-line {
    width: 200px;
    /* width: 70%; */
    height: 2px;
    background: green;
    padding: 0;
    margin: 0 0px 0 0px;
}

div.departure-dot {
    width: 6px;
    max-width: 6px;
    min-width: 6px;
    height: 6px;
    min-height: 6px;
    max-height: 6px;
    border-radius: 50%;
    background: green;
    margin-left: 15px;
    margin-right: -1px
}

div.arrival-dot {
    width: 6px;
    max-width: 6px;
    min-width: 6px;
    height: 6px;
    min-height: 6px;
    max-height: 6px;
    border-radius: 50%;
    background: green;
    margin-right: 15px;
    margin-left: -1px
}



td.td-price {
    /* text-align: right !important;  */
    /* vertical-align: right  !important; */
    /* padding: 8px; */
    /* width: 100px; */
    /* display: flex; */
    /* justify-content: flex-end; */
    /* align-items: center; */
    /* display: flex; */
}

.price {
    font-size: 0.9em;
    background: red;
    color: white;
    /* width: 50px; */
    width: fit-content;
    border-radius: 3px;
    padding: 4px 10px 4px 10px;
    cursor: pointer;
    margin-right: 10px;
    margin-left: auto;
}


tr {
    height: auto;
}

td {
    height: 100%;
}


input[type="time"]::-webkit-calendar-picker-indicator{
  filter: invert(48%) sepia(13%) saturate(3207%) hue-rotate(130deg) brightness(95%) contrast(80%);
}

</style>
