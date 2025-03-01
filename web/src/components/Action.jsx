'use client'
import React from 'react';
import { Heading, FormControl, FormLabel, Select, Textarea, Text, VStack, HStack, Input, Button, Box } from '@chakra-ui/react';
import OnChainContext from './OnChainContext';
import {bigIntToDecimal, decimalToBigInt} from '../utils/decimal';

function Action({ index, onChainInfo }) {
    const [action, setAction] = React.useState(null);
    
    React.useEffect(() => {
        if (!onChainInfo) return;
        (async () => {
            const a = await onChainInfo.cDoRacle.getAction(index);
            setAction(a);
        }) ();
    }, [onChainInfo]);

    const onTake = async () => {
        try{
console.log("Take action", index);
            const txApprove = await onChainInfo.cDoRacleToken.approve(onChainInfo.cDoRacle.target, action.guarantee)
            await txApprove.wait()
console.log("Approval OK");
            const tx = await onChainInfo.cDoRacle.takeAction(index)
            const r = await tx.wait()
            window.alert('Completed. Block hash: ' + r.blockHash);
        } catch(e) {
            window.alert(e.message + "\n" + (e.data?e.data.message:""))
        }
    }

    const onExecute = async () => {
        try{
            const tx = await onChainInfo.cDoRacle.executeAction(index)
            const r = await tx.wait()
            window.alert('Completed. Block hash: ' + r.blockHash);
        } catch(e) {
            window.alert(e.message + "\n" + (e.data?e.data.message:""))
        }
    }

    const onDispute = async () => {
        try{
            const txApprove = await onChainInfo.cDoRacleToken.approve(onChainInfo.cDoRacle.target, action.guarantee)
            await txApprove.wait()
            const tx = await onChainInfo.cDoRacle.disputeAction(index)
            const r = await tx.wait()
            window.alert('Completed. Block hash: ' + r.blockHash);
        } catch(e) {
            window.alert(e.message + "\n" + (e.data?e.data.message:""))
        }
    }

    const onVoteYes = async () => {
        try{
            const txApprove = await onChainInfo.cDoRacleToken.approve(onChainInfo.cDoRacle.target, await onChainInfo.cDoRacle.VOTE_REWARD())
            await txApprove.wait()
            const tx = await onChainInfo.cDoRacle.onVote(index, true)
            const r = await tx.wait()
            window.alert('Completed. Block hash: ' + r.blockHash);
        } catch(e) {
            window.alert(e.message + "\n" + (e.data?e.data.message:""))
        }
    }

    const onVoteNo = async () => {
        try{
            const txApprove = await onChainInfo.cDoRacleToken.approve(onChainInfo.cDoRacle.target, await onChainInfo.cDoRacle.VOTE_REWARD())
            await txApprove.wait()
            const tx = await onChainInfo.cDoRacle.onVote(index, false)
            const r = await tx.wait()
            window.alert('Completed. Block hash: ' + r.blockHash);
        } catch(e) {
            window.alert(e.message + "\n" + (e.data?e.data.message:""))
        }
    }

    const onSettle = async () => {
        try{
            const tx = await onChainInfo.cDoRacle.settleAction(index)
            const r = await tx.wait()
            window.alert('Completed. Block hash: ' + r.blockHash);
        } catch(e) {
            window.alert(e.message + "\n" + (e.data?e.data.message:""))
        }
    }

    const onClaim = async () => {
        try{
            const tx = await onChainInfo.cDoRacle.claimVoterReward(index)
            const r = await tx.wait()
            window.alert('Completed. Block hash: ' + r.blockHash);
        } catch(e) {
            window.alert(e.message + "\n" + (e.data?e.data.message:""))
        }
    }

    if (!action) return("Please wait...")
    return (<OnChainContext.Provider value={onChainInfo} >
        <VStack width='50%' p={4} align='center' borderRadius='md' shadow='lg' bg='black'>
            <Heading as="h3" size="md">Action {index}</Heading>
            <Text>Description: {action.description}</Text>
            <Text>Reward: {action.reward}</Text>
            <Text>Guarantee: {action.guarantee}</Text>
            <Text>Execution deadline: {action.executeDeadline}</Text>
            <Text>Dispute deadline: {action.disputeDeadline}</Text>
            <Text>Vote deadline: {action.description}</Text>
            <Text>Vote count: {action.voteCount}</Text>
            <Text>Votes ok: {action.votesExecuted}</Text>
            <Text>Requester: {action.requester}</Text>
            <Text>Executor: {action.executor}</Text>
            <Text>Disputer: {action.disputer}</Text>
            <Text>Execution timestamp: {action.executedTimestamp}</Text>
            <HStack>
                <Button color='black' bg='green' size='lg' onClick={onTake}>Take</Button>
                <Button color='black' bg='green' size='lg' onClick={onExecute}>Execute</Button>
                <Button color='black' bg='red' size='lg' onClick={onDispute}>Dispute</Button>
                <Button color='black' bg='green' size='lg' onClick={onVoteYes}>Vote yes</Button>
                <Button color='black' bg='red' size='lg' onClick={onVoteNo}>Vote no</Button>
                <Button color='black' bg='green' size='lg' onClick={onSettle}>Settle</Button>
                <Button color='black' bg='green' size='lg' onClick={onClaim}>Claim Vote Reward</Button>
            </HStack>
        </VStack>
    </OnChainContext.Provider>);
}

export default Action;