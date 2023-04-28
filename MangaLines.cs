using UnityEngine;

public class MangaLines : MonoBehaviour 
{
    public Material material;
    public float speed;

    void start()
    {
        material.SetFloat("_Speed", speed);
        GetComponent<Renderer>().material = material;
    }
}