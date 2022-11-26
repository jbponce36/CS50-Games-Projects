using UnityEngine;
using UnityEngine.UI;
using System.Collections;

public class YouWonScoreText : MonoBehaviour
{
    public Text text;
    
    void Start () {
        text = GetComponent<Text>();
        text.text = GameMaster.GetPlayerScore().ToString();
    }
}
