using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class MainMenu : MonoBehaviour
{
    public void GoToMainMenu()
    {
        SoundManager.PlayExitSound();
        SceneManager.LoadScene("MainMenuScene");
    }
    
    public void PlayGame()
    {
        SoundManager.PlayPlaySound();
        GameMaster.ResetPlayerStats();
        SceneManager.LoadScene("PlayScene");
    }

    public void ExitGame()
    {
        Debug.Log("EXIT");
        SoundManager.PlayExitSound();
        Application.Quit();
    }
}
