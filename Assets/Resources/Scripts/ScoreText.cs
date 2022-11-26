using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class ScoreText : MonoBehaviour
{
    public Text text;
    
    void Start () {
        text = GetComponent<Text>();
    }

    void Update () {
        text.text = GameMaster.GetPlayerScore().ToString();
    }
}
