//
//  KeyFetcher.swift
//  StandUp-iOS
//
//  Created by Peter on 12/01/19.
//  Copyright © 2019 BlockchainCommons. All rights reserved.
//

import Foundation
import LibWally

class KeyFetcher {
    
    let derivationPath = UserDefaults.standard.object(forKey: "derivation") as! String
    
    func privKey(index: Int, completion: @escaping ((privKey: String?, error: Bool)) -> Void) {
        
        let enc = Encryption()
        enc.getSeed() { (words, error) in
            
            if !error {
                
                let mnenomicCreator = MnemonicCreator()
                
                mnenomicCreator.convert(words: words) { (mnemonic, error) in
                    
                    if !error {
                        
                        if let masterKey = HDKey((mnemonic!.seedHex("")), self.network()) {
                            
                            if let path = BIP32Path(self.derivationPath) {
                                
                                do {
                                    
                                    let account = try masterKey.derive(path)
                                    
                                    if let childPath = BIP32Path("\(index)") {
                                        
                                        do {
                                            
                                            let key = try account.derive(childPath)
                                            
                                            if let keyToReturn = key.privKey {
                                                
                                                let wif = keyToReturn.wif
                                                completion((wif,false))
                                                
                                            } else {
                                                
                                                completion((nil,true))
                                                
                                            }
                                            
                                        } catch {
                                            
                                            completion((nil,true))
                                            
                                        }
                                        
                                    }
                                    
                                } catch {
                                    
                                    completion((nil,true))
                                    
                                }
                                
                            } else {
                                
                                completion((nil,true))
                                
                            }
                            
                        } else {
                            
                            completion((nil,true))
                            
                        }
                        
                    } else {
                        
                        completion((nil,true))
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    func bip32Xpub(completion: @escaping ((xpub: String?, error: Bool)) -> Void) {
        
        let enc = Encryption()
        enc.getSeed() { (words, error) in
            
            if !error {
                
                let mnenomicCreator = MnemonicCreator()
                mnenomicCreator.convert(words: words) { (mnemonic, error) in
                    
                    if !error {
                        
                        if let masterKey = HDKey((mnemonic!.seedHex("")), self.network()) {
                            
                            if let path = BIP32Path(self.derivationPath) {
                                
                                do {
                                    
                                    let account = try masterKey.derive(path)
                                    completion((account.xpub,false))
                                    
                                } catch {
                                    
                                    completion((nil,true))
                                    
                                }
                                
                            } else {
                                
                                completion((nil,true))
                                
                            }
                            
                        } else {
                            
                            completion((nil,true))
                            
                        }
                        
                    } else {
                        
                        completion((nil,true))
                        
                    }
                    
                }
                
            } else {
                
                completion((nil,true))
                
            }
            
        }
        
    }
    
    func bip32Xprv(completion: @escaping ((xprv: String?, error: Bool)) -> Void) {
        
        let enc = Encryption()
        enc.getSeed() { (words, error) in
            
            if !error {
                
                let mnenomicCreator = MnemonicCreator()
                
                mnenomicCreator.convert(words: words) { (mnemonic, error) in
                    
                    if !error {
                        
                        if let masterKey = HDKey((mnemonic!.seedHex("")), self.network()) {
                            
                            if let path = BIP32Path(self.derivationPath) {
                                
                                do {
                                    
                                    let account = try masterKey.derive(path)
                                    
                                    if let xprv = account.xpriv {
                                        
                                        completion((xprv,false))
                                        
                                    } else {
                                        
                                        completion((nil,true))
                                        
                                    }
                                    
                                } catch {
                                    
                                    completion((nil,true))
                                    
                                }
                                
                            } else {
                                
                                completion((nil,true))
                                
                            }
                            
                        } else {
                            
                            completion((nil,true))
                            
                        }
                        
                    } else {
                        
                        completion((nil,true))
                        
                    }
                    
                }
                
            } else {
                
                completion((nil,true))
                
            }
            
        }
        
    }
    
    private func network() -> Network {
        
        var network:Network!
        
        if self.derivationPath == "m/84'/1'/0'/0" {
            
            network = .testnet
            
        } else {
            
            network = .mainnet
            
        }
        
        return network
        
    }
    
}
