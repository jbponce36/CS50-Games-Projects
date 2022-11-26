using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class LivesBar : MonoBehaviour
{
    public Image[] livesBar;
    public int lives;
    
    void Update()
    {
        lives = GameMaster.GetLives();

        Color color;

        for (int i = 0; i < lives; i++) {
            color = livesBar[i].color;
            color.a = 1f;
            livesBar[i].color = color;
        }

        for (int i = lives; i < livesBar.Length; i++) {
            color = livesBar[i].color;
            color.a = 0f;
            livesBar[i].color = color;
        }
    }
}
