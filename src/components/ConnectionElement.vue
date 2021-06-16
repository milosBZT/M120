<template>
    <div class="table-row">
        <div class="pictogram">
        </div>
        <div class="line">

        </div>
        <div class="departure-arrival">

        </div>
        <div class="duration">

        </div>
        <div class="hops">

        </div>
        <div class="track">

        </div>
        <div class="payment-button">
            
        </div>
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
    name: 'ConnectionElement',
    props: {
        data: Object
        // startDestinationLocations: String,
        // startPlace: String,
        // destinationPlace: String,
        // connections: Array
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

    },
}
</script>


<style scoped>

