<template>
<div id="payment-view" class="container menu-element">
    <div class="error-area" v-if="errorMsgs.length">
        <span v-for="(msg, index) in errorMsgs" :key="index" class="error-tag">
            <span class="error-tag">{{msg}}</span>
        </span>
    </div>
    <div class="connections-box">
        <div class="header">
            <div class="header-title">{{ headerTitle }}</div>
            <div class="return-to-connections" @click="$emit('return-to-connections', 'hello')">
                &#60; Verbindungen suchen
            </div>
        </div>
        <div class="input-container">
            <div class="input-area left">
                <div class="input-field">
                    <label for="name">Name</label>
                    <input id="name" class="place-input" v-model="form.name" lazy @keypress="inputKeypress"/>
                </div>
                <div class="input-field right">
                    <label for="surname">Nachname</label>
                    <input id="surname" class="place-input" v-model="form.surname" lazy @keypress="inputKeypress"/>
                </div>
            </div>
            <div class="input-area secondary-row">
                <div class="input-field">
                    <label for="birthday-date">Geburtsdatum</label>
                    <input id="birthday-date" type="date" class="place-input"
                           v-model="form.birthday"
                           @click="inputKeypress"
                           @keypress="renderBirthday(); calculateTicketPrice()"
                           @change="renderBirthday(); calculateTicketPrice()"/>
                </div>
                <div class=" input-field clock-input">
                    <label for="discount-type">Ermässigungen</label>
                    <select id="discount-type" class="place-input" v-model="form.discountOption" @change="calculateTicketPrice">
                        <option value="none" selected>Keine Ermässigungen</option>
                        <option value="halbtax">Halbtax</option>
                    </select>
                </div>
            </div>
            <div class="input-area tertiary-row">
                <div class="class-type-div">
                    <label for="discount-type">Reiseoption</label>
                    <select class="class-input" @click="inputKeypress" v-model="form.classType" @change="calculateTicketPrice">
                        <option value="none" disabled selected>Bitte Reiseklasse wählen</option>
                        <option value="second_class">2. Klasse</option>
                        <option value="first_class">1. Klasse</option>
                    </select>
                </div>

                <div class="one-two-way" @click="oneTwoWayButton(); calculateTicketPrice()">
                    <div v-if="!form.twoWay" class="two-way-button">
                        <span style="white-space: nowrap">{{buttonTwoWayText[0]}}</span>
                    </div>
                    <div v-else class="two-way-button">
                        <span style="white-space: nowrap">{{buttonTwoWayText[1]}}</span>
                    </div>
                </div>

                <div v-if="form.twoWay" class="return-connection">
                    <div class="input-field">
                        <label for="return-date">Rückfahrdatum</label>
                        <input type="date" id="return-date" class="return-date" v-model="form.returnDate" @keypress="inputKeypress" @click="inputKeypress"/>
                    </div>
                    <div class=" input-field clock-input">
                        <label for="clock-input">Uhrzeit</label>
                        <input type="time" id="return-time" class="return-time place-input" v-model="form.returnTime" required @keypress="inputKeypress" @click="inputKeypress"/>
                    </div>
                </div>
            </div>
        </div>
        <div class="search-button-area" @click="goToPayment">
            <button v-tooltip="'fck'" class="search-button">Zur Kasse</button>
        </div>
    </div>
    <div class="ticket-info-box">
        <div class="info-title">{{connection.from}} - {{connection.to}}</div>
        <div class="info-route">{{connection.description}}</div>
        <div class="info-route-label">Abfahrt</div>
        <div class="info-route-arrival">{{connection.departureDateTime}}, Gleis {{connection.track}}</div>
        <div class="info-route-arrival-label">Ankunft</div>
        <div class="info-route-arrival">{{connection.arrivalDateTime}}</div>
        <div class="info-birthday">{{ form.isChild ? 'Kinder' : 'Erwachsene'}}</div>
        <div class="info-hops" v-if="connection.hops">{{connection.hops}}x umsteigen</div>
        <div class="info-discount" v-if="form.discountOption != 'none'">{{discountOptions[1].name}}</div>
        <div class="info-class" v-if="form.classType != 'none'">{{classOptionNames[form.classType]}}</div>
        <div class="info-price">{{calcTicketPrice}} CHF</div>
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
    name: 'PaymentMenu',
    props: {
        data: Object,
        headerTitle: String,
        // startDestinationLocations: String,
        // startPlace: String,
        // destinationPlace: String,
        connection: Object
    },

    data() {
        return {
            news: [],
            options: [],
            exactTitle: '',
            errorMsgs: [],
            form: {
                name: '',
                surname: '',
                birthday: '',
                discountOption: 'none',
                twoWay: false,
                returnTime: '',
                returnDate: '',
                classType: 'none',
                isChild: false
            },

            returnDateTime: '',
            ticketPrice: 214.15,
            calcTicketPrice: 214.15,

            discountOptions: [
                {name: 'keine Ermässigungen', value: 'no_discount'},
                {name: 'Halbtax', value: 'halbtax'}
            ],

            buttonTwoWayText: [
                'Rückfahrt hinzufügen +',
                'Rückfahrt entfernen -'
            ],

            classOptions: [
                {name: 'Bitte Klasse wählen', value: 'none'},
                {name: '1. Klasse + 15.5 CHF', value: 'first_class'},
                {name: '2. Klasse', value: 'second_class'}
            ],

            classOptionNames: {
                first_class: '1. Klasse',
                second_class: '2. Klasse',
            }
        }
    },

    mounted() {
    },


    methods: {

        renderBirthday() {
            const now = moment(new Date(), 'YYYY-MM-DD');
            const birthday = moment(this.form.birthday, 'YYYY-MM-DD');
            const diff = now.diff(birthday, 'years');
            this.form.isChild = diff <= 16;
        },


        async goToPayment(input) {
            console.log({formData: this.form});
            if (this.validateInput()) {
                // this.fetchData();
            }
        },



        calculateTicketPrice() {
            let price = this.ticketPrice;


            if (this.form.discountOption == 'halbtax' || this.form.isChild) {
                console.log("halbtax or child...");
                price /= 2;
            }


            if (this.form.classType == 'first_class') {
                price += 15.5;
            }

            if (this.form.twoWay) {
                price *= 2;
            }

            this.calcTicketPrice = price;
        },


        changeDiscount() {
            console.log({dicountType: this.form.discountOption});
            if (this.form.discountOption == 'halbtax') {
                console.log('less EXPENSIVE');
                this.calcTicketPrice -= this.ticketPrice / 2;
            } else {
                console.log('more EXPENSIVE');
                this.calcTicketPrice += this.ticketPrice / 2;
            }
        },

        inputKeypress(event) {
            console.log(event.target.id);

            if (event.target.id == 'return-time' || event.target.id == 'return-date') {
                let time = document.querySelector('#return-time');
                let date = document.querySelector('#return-date');

                time.classList.remove('error-input');
                date.classList.remove('error-input');
            }

            event.target.classList.remove('error-input');
        },


        validateInput() {
            let valid = true;
            this.errorMsgs = [];
            if (!this.form.name.length) {
                this.markInputError('#name');
                this.errorMsgs.push('Vornamen angeben');
                valid = false;
            }
            if (!this.form.surname.length) {
                this.errorMsgs.push('Nachnamen angeben');
                this.markInputError('#surname');
                valid = false;
            }

            if (!this.form.birthday.length || this.form.birthday == '') {
                this.markInputError('#birthday-date');
                this.errorMsgs.push('Geburtsdatum angeben');
                valid = false;
            } else {
                if (moment(this.form.birthday).isAfter('2020-01-01', 'day')
                    || moment(this.form.birthday).isBefore('1900-01-01', 'day')) {
                    this.errorMsgs.push('Gültiges Geburtsdatum angeben');
                    this.markInputError('#birthday-date');
                    valid = false;                    
                }
            }

            console.log({CLASS_TYPE: this.form.classType});
            if (this.form.classType == 'none') {
                 this.errorMsgs.push('Reiseklasse angeben');
                this.markInputError('.class-input');
                valid = false;
            }

            if (this.form.twoWay) {
                if (!this.form.returnDate.length || this.form.returnDate == '') {
                    this.errorMsgs.push('Rückfahrdatum angeben');
                    this.markInputError('input.return-date');
                    valid = false;
                }
                if (!this.form.returnTime.length || this.form.returnTime == '') {
                    this.markInputError('input.return-time');
                    valid = false;
                }

                const returnDateTime = `${this.form.returnDate} ${this.form.returnTime}`;
                const toDateTime = this.connection.arrivalDateTime;

                console.log({
                    real: toDateTime,
                    have: returnDateTime
                });


                if (moment(returnDateTime).isSameOrBefore(toDateTime, 'minute')) {
                    this.markInputError('input.return-date');
                    this.markInputError('input.return-time');
                    this.errorMsgs.push('Rückfahrdatum muss nach der Ankunftszeit liegen');
                    valid = false;
                }
            }

            // this.errorMsgs = [...new Set(this.errorMsgs)];
            return true;
        },


        markInputError(htmlElement) {
            let element = document.querySelector(`${htmlElement}`);
            console.log({gotElem: element});
            if (element) {
                element.classList.add('error-input');
            }
        },


        oneTwoWayButton() {
            console.log("clicked...");
            this.form.twoWay = !this.form.twoWay;
            console.log(this.form);

            const button = document.querySelector('.two-way-button');
            if (this.form.twoWay) {
                button.classList.add('active');
            } else {
                button.classList.remove('active');
            }
        }
    },
}
</script>


<style scoped>

* {
    font-family: 'HeaderFontRegular';
}
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


.info-route-label {
    margin-top: 10px;
    color: var(--on-bg-color-medium);
}

.info-route-arrival-label {
    margin-top: 10px;
    color: var(--on-bg-color-medium);
}


div.one-two-way {
    /* height: 20px; */
    height: 100%;
    /* width: 50px; */
    padding: 10px;
    display: flex;
    align-items: flex-end;
    /* background: green; */
}

.two-way-button {
    cursor: pointer;
    padding: 10px 15px 10px 10px;
    border-radius: 5px;
    border: 1px solid transparent;
    color: var(--on-bg-color-light);
    margin-bottom: 6px;
    font-size: 0.9em;
}

.two-way-button:hover {
    border: 1px solid var(--border-color);
    background: var(--bg-color-lighter);
}


.active {
    border: 1px solid var(--border-color);
}


.return-connection {
    display: flex;

    /* width: fit-content !important; */
}

.return-date {
    width: fit-content;
    margin-right: 20px;
}

.class-type-div {
    display: flex;
    flex-direction: column;
    color: var(--on-bg-color-light);
    padding-left: 10px;
    padding-right: 10px;
    /* margin-right: 20px !important; */
    /* margin-left: auto !important; */
}


.container {
    width: 100%;
    margin-top: 55px;
    display: flex;
    justify-content: center;
}

::-webkit-calendar-picker-indicator {
    filter: invert(1);
}

.return-to-connections {
    white-space: nowrap;
    padding: 5px;
    padding-right: 10px;
    cursor: pointer;
    /* width: 50px; */
    /* height: 10px; */
    color: var(--secondary-color-light);
    /* background: green; */
}

.return-to-connections:hover {
    text-decoration: underline;
}


.ticket-info-box {
    /* transition: all linear 200ms; */
    width: 250px;
    min-height: 300px;
    margin-left: 20px;
    max-height: 400px;
    border-radius: 16px;
    padding: 12px;
    border: 1px solid var(--bg-color);
    color: var(--on-bg-color-light);
    background: rgb(25, 27, 31);
    box-shadow: rgb(0 0 0 / 1%) 0px 0px 1px, rgb(0 0 0 / 4%) 0px 4px 8px, rgb(0 0 0 / 4%) 0px 16px 24px, rgb(0 0 0 / 1%) 0px 24px 32px;
}

.info-title {
    font-size: 1.05em;
    margin-bottom: 15px;
    /* font-family: 'HeaderFontBold'; */
}

.info-route-departure, .info-route-arrival {
    /* color: var(--on-bg-color-medium); */
}

.info-hops {
    font-size: 0.8em;
    padding-top: 10px;
    color: var(--on-bg-color-medium);
}


.info-price {
    border-top: 1px solid var(--border-color);
    margin-top: 20px;
    padding-top: 10px;
    /* margin-top: auto !important; */
    /* margin-bottom: 10px !important; */
    font-size: 1.2em;


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
    /* transition: all linear 100ms; */
    display: flex;
    flex-direction: column;
    /* margin-top: 55px; */
    width: 40%;
    min-width: 700px;
    max-width: 800px;
    /* height: 50%; */
    height: max-content;
    padding: 8px;
    background: rgb(25, 27, 31);
    box-shadow: rgb(0 0 0 / 1%) 0px 0px 1px, rgb(0 0 0 / 4%) 0px 4px 8px, rgb(0 0 0 / 4%) 0px 16px 24px, rgb(0 0 0 / 1%) 0px 24px 32px;
    border-radius: 24px;
    /* border-radius: 5px; */
    /* margin-top: 1rem; */
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

input, select {
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


.search-button-area {
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

button.search-button {
    /* background: var(--secondary-color-semi); */
    /* color: var(--on-bg-color-medium); */
    /* background: var(--secondary-color); */
    background: var(--button-color);
    color: white;
    outline: none;
    border: none;
    font-size: 1.1em;
    box-shadow: none;
    height: 55px;
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




input.return-time {
    width: 100px;
}

div.secondary-row {
    justify-content: flex-start;
    margin-top: -15px;
    /* margin-bottom: 10px; */
}

.tertiary-row {
    justify-content: flex-start !important;
    /* margin-top: -5px; */
    margin-bottom: 10px;
    width: 100%;
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


</style>

