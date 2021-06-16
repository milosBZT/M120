<template>
  <div class="header-container">
      <div class="logo-div">
        <img style="width: 40px; height: auto" src="../assets/images/delta_project_icon.png"/>
      </div>
      <div class="wallet-div">
          <div class="wallet">0xfad349...ac97</div>
      </div>
      <!-- <i class="fa fa-twitter"></i> -->
    <!-- <div class="menu-items-area">
        <div>Home</div>
        <div>Contracts</div>
        <div></div>
        <div></div>
    </div> -->
  </div>
</template>

<script>
export default {
  name: 'Header',

  methods: {
    sayHi: () => {console.log('helloXXXXX')}
  }
}
</script>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
@import url('../css/fonts.css');
@import url('../css/root.css');


div.header-container {
    display: flex;
    /* border-top: 1px solid var(--border-color-grey); */
    /* background: rgb(245, 251, 255); */
}


div.logo-div {
  display: flex;
  align-items: center;
  width: 80px;
  justify-content: center;
}


div.wallet-div {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    padding-right: 15px;
    margin-right: 0;
    margin-left: auto;
    /* background: green; */
    height: 100%;
    width: 200px;
}

div.wallet {
    font-family: 'HeaderFontRegular';
    /* height: 30px; */
    padding: 8px 15px 8px 15px;
    border-radius: 10px;
    color: var(--on-bg-color-light);
    /* background: rgb(241, 241, 241); */
    background: var(--primary-color-dimm);
}


</style>
