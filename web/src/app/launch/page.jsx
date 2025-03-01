'use client'
import Head from 'next/head'
import React from 'react'
import { Box } from '@chakra-ui/react'

import TitleBar from '@/components/TitleBar'
import LinkBar from '@/components/LinkBar'
import BodyLaunch from '@/components/BodyLaunch'

export default function Home() {
  const [signer, setSigner] = React.useState(null);
  const [address, setAddress] = React.useState(null);
  const [symbol, setSymbol] = React.useState('');
  const [focus, setFocus] = React.useState('launch');

  return (<>
    <Head>
      <title>Launch Token</title>
      <meta name="description" content="Launch Token" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <link rel="icon" href="/favicon.ico" />
    </Head>
    <Box bg='green.800' w='100%' h='100%' p={4} color='white' align='center'>
      <TitleBar setSigner={setSigner} address={address} setAddress={setAddress} setSymbol={setSymbol} />
      <LinkBar focus={focus} setFocus={setFocus} />
      <br/>
      <BodyLaunch signer={signer} address={address} nativeSymbol={symbol}/>
    </Box>
  </>)
}
