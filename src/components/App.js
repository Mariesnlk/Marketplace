import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from '@metamask/detect-provider';
import KryptoPaint from '../abis/KryptoPaint.json';
import { MDBCard, MDBCardBody, MDBCardTitle, MDBCardText, MDBCardImage, MDBBtn } from 'mdb-react-ui-kit';
import './App.css';

class App extends Component {

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    //detect ethereum provider
    async loadWeb3() {
        const provider = await detectEthereumProvider();

        if (provider) {
            // From now on, this should always be true:
            // provider === window.ethereum
            // startApp(provider); // initialize your app
            console.log('Ethereum wallet is connected!');
            window.web3 = new Web3(provider);
        } else {
            console.log('Please install MetaMask!');
        }

    }

    async loadBlockchainData() {
        const web3 = window.web3;
        const accounts = await web3.eth.getAccounts();
        this.setState({ account: accounts[0] });
        console.log(this.state.account);

        const networkId = await web3.eth.net.getId()
        console.log(networkId);

        const networkData = KryptoPaint.networks[networkId];
        console.log(networkData)

        if (networkData) {

            //a var abi set to the contract abi
            const abi = KryptoPaint.abi;
            //a var address set to networkData address
            const address = networkData.address;
            //a var contract which grabs a new instance of web3 eth contract
            const contract = new web3.eth.Contract(abi, address);

            this.setState({ contract })
            console.log("Contract " + this.state.contract)

            const totalSupply = await contract.methods.totalSupply().call()
            this.setState({ totalSupply })

            console.log(this.state.totalSupply)

            //set up an array to keep track of tokens
            for (let i = 1; i <= totalSupply; i++) {
                const kryptoPaint = await contract.methods.kryptoPaintz(i - 1).call()
                // ... update the state and merge 
                this.setState({
                    kryptoPaintz: [...this.state.kryptoPaintz, kryptoPaint]
                })
            }

            console.log(this.state.kryptoPaintz)

        } else {
            window.alert('Smart contract not deployed')
        }

    }

    mint = (kryptoPaint) => {
        this.state.contract.methods.mint(kryptoPaint).send({ from: this.state.account })
            .once('receipt', (receipt) => {
                this.setState({
                    kryptoPaintz: [...this.state.kryptoPaintz, KryptoPaint]
                })
            })
    }

    //props helps us to state from one component to another
    constructor(props) {
        super(props);
        this.state = {
            account: '',
            contract: null,
            totalSupply: 0,
            kryptoPaintz: []
        }
    }

    render() {
        return (
            <div className="container-filled">
                {console.log(this.state.kryptoPaintz)}
                <nav className="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
                    <div className="navbar-brand col-sm-3 col-md-3 mr-0" style={{ color: 'white' }}>
                        Krypto Paintz NFTs (Non Fungible Tokens)
                    </div>
                    <ul className="navbar-nav px-3">
                        <li className="nav-item text-nowrap d-none d-sm-none 
                        d-sm-block">
                            <small className="text-white">
                                {this.state.account}
                            </small>
                        </li>

                    </ul>
                </nav>

                <div className="container-fluid mt-1">
                    <div className="row">
                        <main role="main" className="col-lg-12 d-flex text-center">
                            <div className="content mr-auto ml-auto" style={{ opacity: "0.8" }}>
                                <h1 style={{ color: "black" }}>NFT MAPKETPLACE</h1>

                                <form onSubmit={(event) => {
                                    event.preventDefault()
                                    const kryptoPaint = this.kryptoPaint.value
                                    this.mint(kryptoPaint)
                                }}>
                                    <input
                                        type='text'
                                        placeholder='Add a file location'
                                        className='form-control mb-1'
                                        ref={(input) => this.kryptoPaint = input}
                                    />
                                    <input style={{ margin: '6px' }}
                                        type='submit'
                                        className='btn btn-primary btn-black'
                                        value='MINT'
                                    />
                                </form>
                            </div>
                        </main>
                    </div>
                    <hr></hr>
                    <div className="row textCenter">
                        {this.state.kryptoPaintz.map((kryptoPaint, key) => {
                            return (
                                <div>
                                    <div>
                                        <MDBCard className="token img" style={{ maxWidth: "55rem" }} >
                                            <MDBCardImage src={kryptoPaint} position="top" height="250rem" style={{ marginRight: "4px" }} />
                                            <MDBCardBody >
                                                <MDBCardTitle> KryptoPaint </MDBCardTitle>
                                                <MDBCardText>Description for our kryptoPaint</MDBCardText>
                                                <MDBBtn href={kryptoPaint}>Download</MDBBtn>
                                            </MDBCardBody>
                                        </MDBCard>
                                    </div>
                                </div>
                            )
                        })}
                    </div>


                </div>
            </div>
        )
    }
}

export default App;