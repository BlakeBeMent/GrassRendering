using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InstancedGrass : MonoBehaviour
{
    [SerializeField, Tooltip("Grass blade mesh")]
    private Mesh mesh;

    [SerializeField, Min(1), Tooltip("Width of the grass field")] 
    float width;

    [SerializeField, Min(1), Tooltip("How many grass blades to render")]
    int density;

    [SerializeField, Tooltip("Grass shader")]
    Shader shader;

    RenderParams renderParams = new RenderParams();
    Material material;

    public ComputeShader computeShader;
    ComputeBuffer positionsBuffer;

    static readonly int
        positionsId = Shader.PropertyToID("_Positions"),
        widthId = Shader.PropertyToID("_Width"),
        densityId = Shader.PropertyToID("_Density"),
        rotationId = Shader.PropertyToID("_Rotation");

    private void OnEnable()
    {
        positionsBuffer = new ComputeBuffer(density * density, sizeof(float) * 2);
        computeShader.SetBuffer(0, positionsId, positionsBuffer);
        computeShader.SetFloat(widthId, width);
        computeShader.SetInt(densityId, density);

        int groups = Mathf.CeilToInt(density / 8f);
        computeShader.Dispatch(0, groups, groups, 1);

        material = new Material(shader);
        renderParams.material = material;
        renderParams.worldBounds = new Bounds(Vector3.zero, new Vector3(width, 1, width));
        material.SetBuffer(positionsId, positionsBuffer);
    }

    private void OnDisable()
    {
        positionsBuffer.Release();
        positionsBuffer = null;
    }

    private void Update()
    {
        for(float i = -45f; i <= 45f; i += 45f)
        {
            renderParams.material = new Material(shader);
            renderParams.material.SetBuffer(positionsId, positionsBuffer);
            renderParams.material.SetFloat(rotationId, Mathf.Deg2Rad * i);
            Graphics.RenderMeshPrimitives(renderParams, mesh, 0, density * density);
        }
    }

    #if UNITY_EDITOR
    private void OnDrawGizmosSelected()
    {
        // draw bounding box
        Gizmos.color = Color.green;
        Gizmos.DrawWireCube(renderParams.worldBounds.center, renderParams.worldBounds.size);
    }
    #endif
}
