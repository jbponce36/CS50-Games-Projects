using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PauseMenu : MonoBehaviour
{
    public static bool gamePaused = false;
    public GameObject pauseMenuUI;

    void Update ()
    {
        if (Input.GetKeyDown(KeyCode.Escape)) {
            if (gamePaused) {
                Resume();
            } else {
                Pause();
            }
        }
    }

    void Pause () {
        gamePaused = true;
        Time.timeScale = 0f;
        pauseMenuUI.SetActive(true);
        SoundManager.PlayPauseSound();
    }

    public void Resume () {
        gamePaused = false;
        Time.timeScale = 1f;
        pauseMenuUI.SetActive(false);
        SoundManager.PlayResumeSound();
    }

    public void Restart () {
        gamePaused = false;
        Time.timeScale = 1f;
        SoundManager.PlayPlaySound();
        GameMaster.ResetPlayerStats();
        SceneManager.LoadScene("PlayScene");
    }

    public void GoToMainMenu () {
        gamePaused = false;
        Time.timeScale = 1f;
        SoundManager.PlayExitSound();
        SceneManager.LoadScene("MainMenuScene");
    }
}
