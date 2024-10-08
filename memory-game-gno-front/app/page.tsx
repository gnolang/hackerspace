'use client';
import {useContext, useEffect} from "react";
import AccountContext from "@/app/context/AccountContext";
import {AdenaService} from "@/app/adena/adena";
import Connect from "@/app/components/Connect";

export default function Home() {

    const {address} = useContext(AccountContext);

  return (
      <div className="flex flex-col items-center justify-center min-h-screen p-8">
            <h1 className="text-3xl font-bold">Welcome to the Memory Game</h1>
            <p className="text-xl mt-4">Your address: {address}</p>
      </div>
  );
}
