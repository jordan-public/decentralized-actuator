'use client'
import React from 'react';
import { Heading, FormControl, FormLabel, Select, Textarea, Text, VStack, HStack, Input, Button, Box } from '@chakra-ui/react';
import { ethers } from 'ethers';
import aDoRacle from '../artifacts/DoRacle.json';
import aDoRacleToken from '../artifacts/DoRacleToken.json';
import OnChainContext from './OnChainContext';
import {bigIntToDecimal, decimalToBigInt} from '../utils/decimal';
import Action from './Action';

function Body({ signer, address }) {
    const [onChainInfo, setOnChainInfo] = React.useState(null)
    const [actionCount, setActionCount] = React.useState(0);

    React.useEffect(() => {
        if (!signer) return;
        (async () => {
            const cDR = new ethers.Contract(aDoRacle.contractAddress, aDoRacle.abi, signer);
            console.log("cDR: ", cDR);
            console.log("cDR address from ABI", aDoRacle.contractAddress);
            console.log("cDR address", cDR.target);
            const tokenAddress = await cDR.tokenAddress();
            console.log("Token address", tokenAddress);
            const cT = new ethers.Contract(tokenAddress, aDoRacleToken.abi, signer);
            console.log("cDT address", cT.target);
            setOnChainInfo({signer: signer, address: address, cDoRacle: cDR, cDoRacleToken: cT})
        }) ();
    }, [signer, address]);

    React.useEffect(() => {
        if (!onChainInfo) return;
        (async () => {
            const c = await onChainInfo.cDoRacle.getActionCount();
            console.log("Action count", parseInt(c));
            setActionCount(parseInt(c));
        }) ();
    }, [onChainInfo]);

    if (!signer) return(<><br/>Please connect!</>)
    if (!onChainInfo) return("Please wait...")
    return (<OnChainContext.Provider value={onChainInfo} >
        <VStack width='50%' p={4} align='center' borderRadius='md' shadow='lg' bg='black'>
            <Heading as="h3" size="md">Actions</Heading>
            {Array.from({ length: actionCount }, (_, i) => (
                <Action key={i} index={i} onChainInfo={onChainInfo}></Action>
            ))}
        </VStack>
    </OnChainContext.Provider>);
}

export default Body;