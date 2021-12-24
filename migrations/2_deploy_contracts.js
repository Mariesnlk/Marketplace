const KryptoPaint = artifacts.require("KryptoPaint");

//to deploy is run to anonym funct 
module.exports = function(deployer) {
    deployer.deploy(KryptoPaint);
};
