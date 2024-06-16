import { useState } from "react";
import reactLogo from "./assets/react.svg";
import viteLogo from "/vite.svg";
import "./App.css";
import json from "./abi/TOSBT.json";

import { ethers } from "ethers";

import { GelatoRelay, CallWithERC2771Request } from "@gelatonetwork/relay-sdk";

const relay = new GelatoRelay();
const CONTRACT_ADDRESS = "";
const ABI = json.abi;
const RELAY_API_KEY = "";

function App() {
  const [count, setCount] = useState(0);
  const [currentAccount, setCurrentAccount] = useState("");

  const connect = async () => {
    try {
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const { ethereum } = window as any;
      if (!ethereum) {
        alert("Get MetaMask!");
        return;
      }
      const accounts = (await ethereum.request({
        method: "eth_requestAccounts",
      })) as string[];
      console.log("Connected: ", accounts[0]);
      setCurrentAccount(accounts[0]);
    } catch (error) {
      console.log(error);
    }
  };

  const mint = async () => {
    try {
      console.log("minting");
      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const { ethereum } = window as any;
      if (ethereum) {
        const provider = new ethers.BrowserProvider(ethereum);
        const signer = await provider.getSigner();
        const user = await signer.getAddress();
        const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
        const { data } = await contract.mintSBT.populateTransaction(
          currentAccount,
          "https://"
        );
        console.log("Contract: ", contract);
        console.log("signer: ", signer);
        console.log("user: ", user);
        console.log("data: ", data);
        contract.on("SBTMinted", (recipient, tokenId) => {
          console.log(
            `NFT minted! Recipient: ${recipient}, Token ID: ${tokenId.toString()}`
          );
          alert(
            `NFT minted! Recipient: ${recipient}, Token ID: ${tokenId.toString()}`
          );
        });

        const request: CallWithERC2771Request = {
          chainId: (await provider.getNetwork()).chainId,
          target: CONTRACT_ADDRESS,
          data: data,
          user: user,
        };
        const { taskId } = await relay.sponsoredCallERC2771(
          request,
          provider,
          RELAY_API_KEY
        );
        console.log("Complete！", taskId);
        alert("Minted successfully");
      } else {
        console.error("ethereum objectがない");
      }
    } catch (error) {
      alert("失敗");
      console.error(error);
    }
  };

  return (
    <>
      <div>
        {currentAccount ? (
          <>
            <div className="font-bold">接続済み</div>
            <div>アカウント: {currentAccount}</div>
            <div className="flex justify-center items-center my-4">
              <button
                className="p-4 bg-emerald-400 content-center"
                onClick={mint}>
                NFTを作成
              </button>
            </div>
          </>
        ) : (
          <button className="p-4 bg-emerald-400 h-12" onClick={connect}>
            接続する
          </button>
        )}
        <a href="https://vitejs.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <h1>Vite + React</h1>
      <div className="card">
        <button onClick={() => setCount((count) => count + 1)}>
          count is {count}
        </button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>
      </div>
      <p className="read-the-docs">
        Click on the Vite and React logos to learn more
      </p>
    </>
  );
}

export default App;
