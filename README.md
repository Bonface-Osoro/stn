# Secure Texting over Non-cooperative Networks (stn)
Radio systems are vulnerable to cyber attacks. This may be in the form of denial of service, jamming, interference and blocking among others. This may be a huge problem especially in high priority domains such as healthcare emergencies and military missions. In the case of military battlefield, the adversary relies on the identity of the user (combat soldier) to intercept or block the message. Communicating over open civilain cellular networks is one solution that can be applied to avoid intentional malcious attacks to aid soldiers in the ground. Such a system referred here as `windtexter` relies on anonymity and camouflage as shown in `Figure 1`. 

## Figure 1 Illustration of Secure Texting over Open Non-Cooperative Networks.
<p align="center">
  <img src="/docs/windtexter.png" />
</p>

This `windtexter` repository provides a code to simulate an attcke scenario for users communicating over cellular networks (2G, 3G, 4G and 5G). The model involves a jammer moving over space and time and broadcasting a replica signal to prevent the user from communicating with the cellular transmiter. This is simulated across all the four cellular generation technologies.

Citation
---------
Osoro, B., & Oughton, E. (2022). Spatial Modelling of Jamming Secure Texts over Non-cooperative Networks (December 18, 2022).

Example Method
==============

The method is based on agent based modelling (ABM). The transmitter, user (soldier) and the jammers are treated as agents in a 70 x 70 km grid. The transmitter is static while the users and the jammers move randomly within the grid. The difference in euclidean distance between the transmitter and the jammer results in various interference power.

Similarly, the user and transmitter distance changes resulting to various receiver power. The Euclidean distance in both cases (user  and jammer) results in various path loss. The path loss contributes to differing interfernce and received power causing resulting to varying signal to interference plus noise (SINR). `Figure 2` illustrates this method.

## Figure 2 Spatial Modelling of the SINR.
<p align="center">
  <img src="/docs/Box_model.png" />
</p>

Example Results
==============

The `windtexter` repository estimates the SINR for different user and jammer positions within the 70 X 70 km grid. The empirical cumulative density function results for the modelling are also generated to illustrate the distribution of the values as shown in `Figure 3`.

## Figure 3 Estimated Interference results from the Spatial Modelling 
<p align="center">
  <img src="/docs/ecdfs.png" />
</p>

Required Data