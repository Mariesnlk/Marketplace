const KryptoBird = artifacts.require("KryptoBird");

//to deploy is run to anonym funct 
module.exports = function(deployer) {
    deployer.deploy(KryptoBird);
};
