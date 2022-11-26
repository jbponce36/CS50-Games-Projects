using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerScore : MonoBehaviour
{
    public static int playerScore = 0;

    public static void AddScore (int score) {
        playerScore += score;
    }
}
