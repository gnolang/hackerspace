// global.d.ts

interface Adena {
    AddEstablish: (name: string) => Promise<void>;
    // Add other methods you may need to call from the Adena SDK here
}

interface Window {
    adena: Adena;
}
