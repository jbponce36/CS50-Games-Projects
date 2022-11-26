using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
    public static SoundManager sm;
    
    void Start(){
        if (sm == null) {
            sm = GameObject.FindGameObjectWithTag("SoundManager").GetComponent<SoundManager>();
        }
    }

    public AudioSource coinSound;
    public AudioSource powerupSound;
    public AudioSource bossExplosionSound;
    public AudioSource playSound;
    public AudioSource exitSound;
    public AudioSource pauseSound;
    public AudioSource resumeSound;
    public AudioSource loseFollowerSound;

    public static void PlayCoinSound () {
        sm.coinSound.Play();
    }

    public static void PlayPowerupSound () {
        sm.powerupSound.Play();
    }

    public static void PlayBossExplosionSound () {
        sm.bossExplosionSound.Play();
    }

    public static void PlayPlaySound () {
        sm.playSound.Play();
    }

    public static void PlayExitSound () {
        sm.exitSound.Play();
    }

    public static void PlayPauseSound () {
        sm.pauseSound.Play();
    }

    public static void PlayResumeSound () {
        sm.resumeSound.Play();
    }

    public static void PlayLoseFollowerSound () {
        sm.loseFollowerSound.Play();
    }
}

