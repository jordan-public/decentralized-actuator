# decentralized-actuator

# Decentralized Actuator for Real World AI Agents

## Abstract

This is a decentralized economically incentivized on-chain actuator that can be used by AI Agents to achieve their real world action objectives. It runs on Ethereum Virtual Machine (EVM). Agents with access to EVM keys can ask anyone for actions that they desire and offer reward for the execution of such actions. Anyone can deposit the required funds to accept the task, execute the desired action and receive the appropriate reward for the execution. If the action is not executed within a dispute period, the acceptance deposit is lost. Anyone can dispute the action correctness, and trigger voting similar to the one in Optimistic Oracles, such as UMA. The voting decides who is right and who shall receive the funds.

## Introduction

### Oracles and Optimistic Oracles

***Oracles*** are a way to enter off-chain data into the blockchain, which can then be read by various smart contracts. This gives the smart contracts access to the Real World information (Sensors). Oracles serve an important role in Decentralized Finance (DeFi).

***Optimistic Oracles*** (notably UMA), allow anyone to enter data into the blockchain (make an ***Assertion***) and make a deposit which vouches for the truthfulness of the Assertion. Anyone can ***Dispute*** this Assertion by depositing funds with the dispute claim. These funds are returned to the Disputer if the corresponding Assertion turns out to be false, in addition to the Asserter's deposit less a small fee imposed by the protocol. The Dispute has to be triggered within a Dispute Period and it has to be Voted on by the Optimistic Oracle stakeholders, which get rewarded for their voting.

### Actuators

In DeFi, all or most actions are executed on-chain causing financial effect. However, Real World actions have to be performed by actuators. This is not a problem if the actuator is called by a single off-chain program and this program has deterministic behavior and is calling for known actions. The Actuators can be designed or integrated specifically for that deterministic program.

For example, an Actuator for controlling a light switch may be developed and integrated with a program which reads on-chain state information when it receives on-chain events. This on-chain state tells the actuator whether to turn the light switch on or off.

#### Problem: Actuators for AI Agents

AI Agents can have an unpredictable yet rational behavior, and call for actions for which there is no available Actuator.

#### Problem: Remote Actuators

What if the AI Agent has to act remotely, and advertize a request for anyone to execute a remote action. How can such remote Actuator be triggered and then trusted?

Example: A fictitious pet, called Bufficon has to be fed regularly, and an AI Agent can be put in charge to make sure the Bufficon is fed. The Bufficon owner has to go out of town and put the AI Agent up to this task. The AI Agent can use Oracles to read the status (mood, hunger) of the Bufficon, but it needs an Actuator in order to perform the feeding. As such Actuator does not exist, it would be useful to be able to ask a volunteer to feed the Bufficon and receive a reward for it. Such volunteer would be hard to find, as there is no standard protocol of incentivization and trusted reward for the action.

## Solution: Do-racle Protocol

We named it ***"Do-racle"*** to hint to the opposite action of Oracle, which acts as Sensor. Do-racle acts as Actuator.

The Do-racle Protocol is a standardized ***economically incentivized*** protocol for performing Decentralized Real World actions, while assuring the following:
-  The actions can be trustlessly requested by anyone who creates an ***Action Description***, and deposits ***Reward*** for the completion of the desired ***Action***.
- Anyone can pick up an advertized Action Description and take responsibility for the task (Action) by depositing ***Guarantee*** funds as stated in the Action Description. The Guarantee funds are lost to the requester and the protocol (shared) of the Action is not performed as described (quality, timeliness).
- 

## Implementation

## Future Work

### Safeguards

