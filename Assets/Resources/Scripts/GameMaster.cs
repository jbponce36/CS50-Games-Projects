using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameMaster : MonoBehaviour
{
    public static GameMaster gm;
    
    void Start(){
        if (gm == null) {
            gm = GameObject.FindGameObjectWithTag("GameMaster").GetComponent<GameMaster>();
        }
    }

    public Transform playerPrefab;
    public Transform spawnPoint;
    public float spawnDelay = 2f;

    public int lives = 3;
    
    public IEnumerator RespawnPlayer (Player player) {
        yield return new WaitForSeconds(spawnDelay);

        Instantiate (playerPrefab, spawnPoint.position, spawnPoint.rotation);
        
        Player newPlayer = GameObject.FindGameObjectWithTag("Player").GetComponent<Player>();
        gm.StartCoroutine(newPlayer.MakeInvincible(12));
    }

    public static void KillPlayer (Player player) {
        gm.lives--;
        Destroy(player.gameObject, player.deadAnimationTime);
        
        if (gm.lives == 0) {
            gm.StartCoroutine(gm.PlayerDiedEndingAnimation(player.explosionSound.clip.length + 1f));
        }
        else {
            gm.StartCoroutine(gm.RespawnPlayer(player));
        }
    }

    public IEnumerator PlayerDiedEndingAnimation(float seconds) {
        yield return new WaitForSeconds(seconds);
        GameOver();
    }

    public static void GameOver () {
        SceneManager.LoadScene("GameOverScene");
    }

    public static void BossDied(float bossDeadAnimationTime) {
        SoundManager.PlayBossExplosionSound();
        gm.StartCoroutine(gm.EndingAnimation(bossDeadAnimationTime + 1f));
    }

    public IEnumerator EndingAnimation(float seconds) {
        yield return new WaitForSeconds(seconds);
        CongratulatePlayer();
    }

    public static void CongratulatePlayer () {
        SceneManager.LoadScene("YouWonScene");
    }

    public static int GetLives() {
        return gm.lives;
    }

    public static void AddScore (int score) {
        PlayerScore.AddScore(score);
    }

    public static int GetPlayerScore() {
        return PlayerScore.playerScore;
    }

    public static void ResetPlayerStats() {
        gm.lives = 3;
        PlayerScore.playerScore = 0;
    }
}
